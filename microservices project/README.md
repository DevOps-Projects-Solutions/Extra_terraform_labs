# File Upload Service with API Gateway, Lambda, S3, and DynamoDB

This project provides a RESTful API for uploading files to an S3 bucket using API Gateway, Lambda functions, and DynamoDB for metadata storage.

## Architecture Overview

- **API Gateway**: Exposes RESTful endpoints for uploading files.
- **Lambda 1**: Generates a pre-signed URL for file uploads and stores initial metadata in DynamoDB.
- **Lambda 2**: Triggered by S3 when a file is uploaded. It processes the file and updates metadata in DynamoDB.
- **S3**: Stores the uploaded files.
- **DynamoDB**: Stores metadata about the files (e.g., file name, size, upload time).

---

## Prerequisites

1. **Terraform**: Ensure Terraform is installed on your machine. You can download it from [here](https://www.terraform.io/downloads.html).

2. **AWS Account**: Ensure you have an AWS account with the necessary permissions to create API Gateway, Lambda, S3, and DynamoDB resources.

---

## Deployment Steps

### Step 1: Deploy the Infrastructure with Terraform

1. Clone this repository to your local machine.
2. Navigate to the Terraform directory:
   ```bash
   cd path/to/terraform/directory
3. Initialize Terraform
   ```bash
   terraform init
4. Review the Terraform plan
   ```bash
   terraform plan
5. Apply the Terraform configuration to deploy the infrastructure
   ```bash
   terraform apply

### Step 2: Upload a File Using the API
1. Generate a Pre-Signed URL:
Replace myfile.txt with the name of your file and run the following command:
   ```bash
   curl -X POST https://ji6wbv8gr6.execute-api.us-east-1.amazonaws.com/prod/files?fileName=myfile.txt
2. Upload the File:
Use the pre-signed URL returned in the previous step to upload your file: 
   ```bash
   curl -X PUT -T myfile.txt "<presigned-url>" -H "Content-Type: application/octet-stream"