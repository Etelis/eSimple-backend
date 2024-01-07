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
REDEEM_URL = os.environ['REDEEM_URL']
TOKEN = os.environ['TOKEN']

# Initialize AWS DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('eSim')

def lambda_handler(event, context):
    try:
        # Extracting eSimID and userID from the event
        eSimID = event['pathParameters']['eSimID']
        userID = event['requestContext']['authorizer']['claims']['sub']

        # Query DynamoDB for the eSim record
        response = table.get_item(Key={'eSimID': eSimID, 'userID': userID})
        if 'Item' not in response:
            return {'statusCode': 404, 'body': json.dumps('eSim not found')}

        # Prepare and send the POST request
        headers = {
            "Authorization": TOKEN,
            "Host": "herobot.me",
            "Content-Type": "application/json"
        }
        payload = {"orderID": eSimID}
        redeem_response = requests.post(REDEEM_URL, headers=headers, json=payload)

        # Check for successful redeem response
        if redeem_response.status_code != 200:
            return {'statusCode': redeem_response.status_code, 'body': redeem_response.text}

        # Extract data from redeem response
        redeem_data = redeem_response.json()
        if not redeem_data.get('success'):
            return {'statusCode': 400, 'body': json.dumps('Redeem failed')}

        eSIM = redeem_data['eSIM']

        # Update the DynamoDB record
        current_date = datetime.now().strftime("%a, %b %d, %Y")
        update_expression = "SET activationCode = :ac, remainingData = :rd, date = :dt, smdpAddress = :sa, qrCode = :qc, is_active = :ia, is_expired = :ie"
        table.update_item(
            Key={'eSimID': eSimID, 'userID': userID},
            UpdateExpression=update_expression,
            ExpressionAttributeValues={
                ':ac': eSIM['activationCode'],
                ':rd': 0,
                ':dt': current_date,
                ':sa': eSIM['smdpAddress'],
                ':qc': eSIM['qrCode'],
                ':ia': True,
                ':ie': False
            }
        )

        return {'statusCode': 200, 'body': json.dumps('eSim updated successfully')}

    except ClientError as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Internal Server Error')}
    except Exception as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Unexpected Error')}
