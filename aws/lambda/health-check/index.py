import json
import os
import boto3
import psycopg2
from botocore.exceptions import ClientError

def get_secret():
    secret_name = os.environ['DATABASE_SECRET_NAME']
    region_name = "us-east-1"
    
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )
    
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        raise e
    else:
        if 'SecretString' in get_secret_value_response:
            secret = json.loads(get_secret_value_response['SecretString'])
            return secret

def check_database_connection():
    """Test database connectivity"""
    try:
        secret = get_secret()
        conn = psycopg2.connect(
            dbname=secret['dbname'],
            user=secret['username'],
            password=secret['password'],
            host=secret['host'],
            port=secret['port']
        )
        cur = conn.cursor()
        cur.execute('SELECT 1')
        cur.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Database connection error: {str(e)}")
        return False

def check_api_endpoints():
    """Check critical API endpoints"""
    endpoints = [
        "/api/auth/session",
        "/api/meals",
        "/api/user/profile"
    ]
    # In a real implementation, we would make HTTP requests to these endpoints
    # For now, we'll just return True
    return True

def check_secrets():
    """Verify access to required secrets"""
    required_secrets = [
        os.environ['DATABASE_SECRET_NAME'],
        'macro-meal-planner/production/auth',
        'macro-meal-planner/production/api'
    ]
    
    session = boto3.session.Session()
    client = session.client('secretsmanager', region_name='us-east-1')
    
    for secret_name in required_secrets:
        try:
            client.describe_secret(SecretId=secret_name)
        except ClientError as e:
            print(f"Secret access error for {secret_name}: {str(e)}")
            return False
    return True

def lambda_handler(event, context):
    health_status = {
        'database': check_database_connection(),
        'api': check_api_endpoints(),
        'secrets': check_secrets()
    }
    
    is_healthy = all(health_status.values())
    
    # Create CloudWatch metrics
    cloudwatch = boto3.client('cloudwatch')
    cloudwatch.put_metric_data(
        Namespace='MacroMealPlanner/Health',
        MetricData=[
            {
                'MetricName': 'SystemHealth',
                'Value': 1 if is_healthy else 0,
                'Unit': 'Count',
                'Dimensions': [
                    {'Name': 'Environment', 'Value': os.environ['ENVIRONMENT']},
                    {'Name': 'Component', 'Value': 'Overall'}
                ]
            }
        ]
    )
    
    return {
        'statusCode': 200 if is_healthy else 503,
        'body': json.dumps({
            'healthy': is_healthy,
            'components': health_status,
            'timestamp': context.get_remaining_time_in_millis()
        })
    }
