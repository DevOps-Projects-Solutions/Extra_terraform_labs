import boto3
import os
import uuid
from datetime import datetime
s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
def lambda_handler(event, context):
    # Get the source bucket and object key from the S3 event
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    source_key = event['Records'][0]['s3']['object']['key']
    # Define the replica bucket
    replica_bucket = os.environ['REPLICA_BUCKET']
    dynamodb_table = os.environ['DYNAMODB_TABLE']
    # Copy the object to the replica bucket
    copy_source = {'Bucket': source_bucket, 'Key': source_key}
    s3_client.copy_object(CopySource=copy_source, Bucket=replica_bucket, Key=source_key)
    # Store metadata in DynamoDB
    table = dynamodb.Table(dynamodb_table)
    table.put_item(
        Item={
            'FileID': str(uuid.uuid4()),
            'SourceBucket': source_bucket,
            'ReplicaBucket': replica_bucket,
            'FileName': source_key,
            'FileSize': event['Records'][0]['s3']['object']['size'],
            'LastModified': datetime.now().isoformat()
        }
    )
    return {
        'statusCode': 200,
        'body': 'File copied and metadata stored successfully!'
    }