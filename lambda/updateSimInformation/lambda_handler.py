# Python code for the Lambda function
import os
import json
import logging
import boto3
from botocore.exceptions import ClientError
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# Environment variables
DYNAMODB_TABLE = os.environ['DYNAMODB_TABLE']

# Initialize AWS DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DYNAMODB_TABLE)

def lambda_handler(event, context):
    try:
        # Scan the DynamoDB table
        response = table.scan()
        items = response.get('Items', [])

        # Iterate through each item and update if necessary
        for item in items:
            expirationDate = item.get('expirationDate')
            if expirationDate and datetime.now() > datetime.strptime(expirationDate, "%Y-%m-%d"):
                # Update is_expired to True
                table.update_item(
                    Key={'eSimID': item['eSimID']},
                    UpdateExpression="SET is_expired = :val",
                    ExpressionAttributeValues={':val': True}
                )

        return {'statusCode': 200, 'body': json.dumps('Expiration check complete')}

    except ClientError as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Internal Server Error')}
    except Exception as e:
        logger.error(e)
        return {'statusCode': 500, 'body': json.dumps('Unexpected Error')}
