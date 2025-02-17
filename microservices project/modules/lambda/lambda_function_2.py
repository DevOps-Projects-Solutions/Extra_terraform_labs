#ProcessUploadedFile​

import json
import boto3
import os
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])
def lambda_handler(event, context):
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        # Get file metadata from S3​
        response = s3.head_object(Bucket=bucket_name, Key=object_key)
        file_size = response['ContentLength']
        # Update metadata in DynamoDB​

        file_id = object_key
        table.update_item(
            Key={'fileId': file_id},
            UpdateExpression='SET #fileSize = :fileSize, #status = :status',
            ExpressionAttributeNames={
                '#fileSize': 'fileSize',
                '#status': 'status'
            },
            ExpressionAttributeValues={
                ':fileSize': file_size,
                ':status': 'processed'
            }
        )

    return {
        'statusCode': 200,
        'body': json.dumps('File processing complete')
    }