#GeneratePresignedUrl​

import json
import boto3
import os
import uuid
from datetime import datetime
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])


def lambda_handler(event, context):
    file_id = str(uuid.uuid4())
    print(f"Generated file ID: {file_id}")
    file_name = event['queryStringParameters']['fileName']
    upload_time = datetime.utcnow().isoformat()
    print(f"Received file name: {file_name}")
    # Generate a pre-signed URL for uploading to S3​
    presigned_url = s3.generate_presigned_url(
        'put_object',
        Params={
            'Bucket': os.environ['BUCKET_NAME'],
            'Key': file_id,
            'ContentType': 'application/octet-stream'
        },

        ExpiresIn=3600
    )
    print(f"Generated presigned URL: {presigned_url}")
   # Save initial metadata to DynamoDb​
    table.put_item(Item={

        'fileId': file_id,
        'fileName': file_name,

        'uploadTime': upload_time,

        'status': 'uploading'
    })
    return {
        'statusCode': 200,
        'body': json.dumps({

            'fileId': file_id,
            'presignedUrl': presigned_url
        })
    }