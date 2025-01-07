import json
import boto3
import os
import logging
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """Secrets Manager Rotation Template
    
    Args:
        event (dict): Lambda dictionary of event parameters. These keys must include the following:
            - SecretId: The secret ARN or identifier
            - ClientRequestToken: The ClientRequestToken of the secret version
            - Step: The rotation step (one of createSecret, setSecret, testSecret, or finishSecret)
            
        context (LambdaContext): The Lambda runtime information
    
    Raises:
        ResourceNotFoundException: If the secret with the specified arn and stage does not exist
        
    """
    arn = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']
    
    # Setup the client
    service_client = boto3.client('secretsmanager')

    # Make sure the version is staged correctly
    metadata = service_client.describe_secret(SecretId=arn)
    if not metadata['RotationEnabled']:
        logger.error("Secret %s is not enabled for rotation" % arn)
        raise ValueError("Secret %s is not enabled for rotation" % arn)
    versions = metadata['VersionIdsToStages']
    if token not in versions:
        logger.error("Secret version %s has no stage for rotation of secret %s." % (token, arn))
        raise ValueError("Secret version %s has no stage for rotation of secret %s." % (token, arn))
    if "AWSCURRENT" in versions[token]:
        logger.info("Secret version %s already set as AWSCURRENT for secret %s." % (token, arn))
        return
    elif "AWSPENDING" not in versions[token]:
        logger.error("Secret version %s not set as AWSPENDING for rotation of secret %s." % (token, arn))
        raise ValueError("Secret version %s not set as AWSPENDING for rotation of secret %s." % (token, arn))
    
    if step == "createSecret":
        create_secret(service_client, arn, token)
    elif step == "setSecret":
        set_secret(service_client, arn, token)
    elif step == "testSecret":
        test_secret(service_client, arn, token)
    elif step == "finishSecret":
        finish_secret(service_client, arn, token)
    else:
        raise ValueError("Invalid step parameter")

def create_secret(service_client, arn, token):
    """Create the secret
    
    This method first checks for the existence of a secret for the passed in token. If one does not exist, it will generate a
    new secret and put it with the passed in token.
    
    Args:
        service_client (client): The secrets manager service client
        arn (string): The secret ARN or other identifier
        token (string): The ClientRequestToken associated with the secret version
        
    Raises:
        ResourceNotFoundException: If the secret with the specified arn does not exist
    """
    # Make sure the current secret exists
    try:
        current_secret = service_client.get_secret_value(SecretId=arn, VersionStage="AWSCURRENT")
        current_dict = json.loads(current_secret['SecretString'])
        
        # Create new secret dict with updated values
        new_dict = current_dict.copy()
        
        # Update the secret values that need rotation
        if 'NEXTAUTH_SECRET' in new_dict:
            new_dict['NEXTAUTH_SECRET'] = generate_random_string(32)
        
        service_client.put_secret_value(SecretId=arn, ClientRequestToken=token, SecretString=json.dumps(new_dict), VersionStages=['AWSPENDING'])
        logger.info("Successfully put secret for ARN %s and version %s." % (arn, token))
    except ClientError as e:
        logger.error("Error creating secret: %s" % e)
        raise e

def set_secret(service_client, arn, token):
    """Set the secret
    
    This method should set the AWSPENDING secret in the service that the secret belongs to. For example, if your secret
    is a database credential, this method should take the value of AWSPENDING and set the user's password to this value in
    the database.
    
    Args:
        service_client (client): The secrets manager service client
        arn (string): The secret ARN or other identifier
        token (string): The ClientRequestToken associated with the secret version
    """
    # This is where you would put code to update external services with the new secret
    # For our case, we don't need to do anything here as our secrets are used directly from Secrets Manager
    pass

def test_secret(service_client, arn, token):
    """Test the secret
    
    This method should validate that the AWSPENDING secret works in the service that the secret belongs to. For example, if the
    secret is a database credential, this method should validate that the user can login with the password in AWSPENDING.
    
    Args:
        service_client (client): The secrets manager service client
        arn (string): The secret ARN or other identifier
        token (string): The ClientRequestToken associated with the secret version
    """
    # This is where you would put code to test the new secret
    # For our case, we don't need to do anything here as our secrets are used directly from Secrets Manager
    pass

def finish_secret(service_client, arn, token):
    """Finish the secret
    
    This method finalizes the rotation process by marking the secret version passed in as the AWSCURRENT secret.
    
    Args:
        service_client (client): The secrets manager service client
        arn (string): The secret ARN or other identifier
        token (string): The ClientRequestToken associated with the secret version
        
    Raises:
        ResourceNotFoundException: If the secret with the specified arn does not exist
    """
    # First describe the secret to get the current version
    metadata = service_client.describe_secret(SecretId=arn)
    current_version = None
    for version in metadata["VersionIdsToStages"]:
        if "AWSCURRENT" in metadata["VersionIdsToStages"][version]:
            if version == token:
                # The correct version is already marked as current, return
                logger.info("Version %s already marked as AWSCURRENT for %s" % (version, arn))
                return
            current_version = version
            break
            
    # Finalize by staging the secret version current
    service_client.update_secret_version_stage(SecretId=arn, VersionStage="AWSCURRENT", MoveToVersionId=token, RemoveFromVersionId=current_version)
    logger.info("Successfully set AWSCURRENT stage to version %s for secret %s." % (token, arn))

def generate_random_string(length):
    """Generate a random string of specified length"""
    import secrets
    import string
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for i in range(length))
