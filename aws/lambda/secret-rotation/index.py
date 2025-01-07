import json
import logging
import os
import boto3
import psycopg2
import secrets
import string
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def generate_password(length=32):
    """Generate a secure random password."""
    alphabet = string.ascii_letters + string.digits + string.punctuation
    while True:
        password = ''.join(secrets.choice(alphabet) for i in range(length))
        if (any(c.islower() for c in password)
                and any(c.isupper() for c in password)
                and any(c.isdigit() for c in password)
                and any(c in string.punctuation for c in password)):
            return password

def get_secret(secret_name):
    """Retrieve a secret from AWS Secrets Manager."""
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=os.environ.get('AWS_REGION', 'us-east-1')
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        logger.error(f"Error getting secret: {str(e)}")
        raise e
    else:
        if 'SecretString' in get_secret_value_response:
            return json.loads(get_secret_value_response['SecretString'])

def update_database_password(host, database, username, old_password, new_password):
    """Update the database user's password."""
    try:
        # Connect with old password
        conn = psycopg2.connect(
            host=host,
            database=database,
            user=username,
            password=old_password
        )
        conn.autocommit = True
        
        with conn.cursor() as cur:
            # Update password
            cur.execute(f"ALTER USER {username} WITH PASSWORD %s", (new_password,))
            
        conn.close()
        return True
    except Exception as e:
        logger.error(f"Error updating database password: {str(e)}")
        return False

def lambda_handler(event, context):
    """Handle the rotation of secrets."""
    try:
        # Get the secret name from the event
        secret_id = event['SecretId']
        step = event.get('Step', 'createSecret')
        
        # Get the current secret
        current_secret = get_secret(secret_id)
        
        if step == 'createSecret':
            # Generate new password
            new_password = generate_password()
            
            # Update secret with new password
            client = boto3.client('secretsmanager')
            client.put_secret_value(
                SecretId=secret_id,
                SecretString=json.dumps({
                    **current_secret,
                    'password': new_password,
                    'pendingPassword': new_password
                })
            )
            
        elif step == 'setSecret':
            # Update database with new password
            success = update_database_password(
                current_secret['host'],
                current_secret['dbname'],
                current_secret['username'],
                current_secret['password'],
                current_secret['pendingPassword']
            )
            
            if not success:
                raise Exception("Failed to update database password")
                
        elif step == 'testSecret':
            # Test the new password
            try:
                conn = psycopg2.connect(
                    host=current_secret['host'],
                    database=current_secret['dbname'],
                    user=current_secret['username'],
                    password=current_secret['pendingPassword']
                )
                conn.close()
            except Exception as e:
                logger.error(f"Test connection failed: {str(e)}")
                raise
                
        elif step == 'finishSecret':
            # Update secret with new password and remove pending
            client = boto3.client('secretsmanager')
            client.put_secret_value(
                SecretId=secret_id,
                SecretString=json.dumps({
                    **current_secret,
                    'password': current_secret['pendingPassword']
                })
            )
            
        return {
            'statusCode': 200,
            'body': json.dumps('Secret rotation completed successfully')
        }
        
    except Exception as e:
        logger.error(f"Secret rotation failed: {str(e)}")
        raise
