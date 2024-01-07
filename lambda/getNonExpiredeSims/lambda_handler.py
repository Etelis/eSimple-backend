import os
import json
import logging
import boto3
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# Environment variables
DYNAMODB_TABLE = os.environ['DYNAMODB_TABLE']
COGNITO_USER_POOL_ID = os.environ['COGNITO_USER_POOL_ID']
COGNITO_REGION = os.environ['COGNITO_REGION']

# Initialize AWS clients
dynamodb = boto3.resource('dynamodb')
cognito_idp = boto3.client('cognito-idp', region_name=COGNITO_REGION)
table = dynamodb.Table(DYNAMODB_TABLE)

def lambda_handler(event, context):
    try:
        # Extract the token from the event
        token = event['headers']['Authorization']

        # Verify the token with Cognito
        response = cognito_idp.get_user(
            AccessToken=token
        )
        user_id = response['Username']

        # Query DynamoDB for eSims associated with the user ID
        response = table.scan(
            FilterExpression=boto3.dynamodb.conditions.Attr('userID').eq(user_id) & boto3.dynamodb.conditions.Attr('is_expired').eq(False)
        )

        if 'Items' not in response or not response['Items']:
            return {'statusCode': 404, 'body': json.dumps('No active eSims found for user')}

        return {'statusCode': 200, 'body': json.dumps(response['Items'])}

    except ClientError as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Internal Server Error')}
    except cognito_idp.exceptions.NotAuthorizedException as e:
        logger.error(e)
        return {'statusCode': 401, 'body': json.dumps('Unauthorized: Invalid Token')}
    except Exception as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Unexpected Error')}