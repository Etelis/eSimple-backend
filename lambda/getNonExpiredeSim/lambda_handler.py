import os
import json
import logging
import boto3
from botocore.exceptions import ClientError
import requests
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# Environment variables
USAGE_URL = os.environ['USAGE_URL']
TOKEN = os.environ['TOKEN']

# Initialize AWS DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('eSim')

def lambda_handler(event, context):
    try:
        # Extracting eSimID from the event
        eSimID = event['pathParameters']['eSimID']

        # Check eSim usage
        headers = {
            "Authorization": TOKEN,
            "Content-Type": "application/json"
        }
        
        payload = {"orderID": eSimID}
        usage_response = requests.post(USAGE_URL, headers=headers, json=payload)

        # Check for successful usage response
        if usage_response.status_code != 200:
            return {'statusCode': usage_response.status_code, 'body': usage_response.text}

        # Extract data from usage response
        usage_data = usage_response.json()
        remainingData = usage_data['remainingData']
        expirationDate = usage_data['expirationDate']
        is_expired = remainingData == 0 or datetime.now() > datetime.strptime(expirationDate, "%Y-%m-%d")

        # Update the DynamoDB record
        update_expression = "SET remainingData = :rd, expirationDate = :ed, is_expired = :ie"
        table.update_item(
            Key={'eSimID': eSimID},
            UpdateExpression=update_expression,
            ExpressionAttributeValues={
                ':rd': remainingData,
                ':ed': expirationDate,
                ':ie': is_expired
            }
        )

        # Return updated eSim information
        updated_item = table.get_item(Key={'eSimID': eSimID})['Item']
        return {'statusCode': 200, 'body': json.dumps(updated_item)}

    except ClientError as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Internal Server Error')}
    except Exception as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Unexpected Error')}

