#!/bin/bash
AWS_KEY_ID=$(terraform output -raw aws_access_key_id)
AWS_SECRET_KEY=$(terraform output -raw aws_secret_access_key)
S3_BUCKET=$(terraform output -raw s3_bucket_name)
AWS_REGION=$(terraform output -raw s3_bucket_region)


if [ "$#" -ne 1 ]; then
    echo "Usage: ./create_s3_dev.sh <microservice_directory>"
    exit 1
fi


MICROSERVICE_DIR=$1
ENV_FILE="${MICROSERVICE_DIR}/.env.development"

KEYS_TO_UPDATE=("AWS_ACCESS_KEY_ID" "AWS_SECRET_ACCESS_KEY" "S3_BUCKET_NAME" "AWS_REGION")


for key in "${KEYS_TO_UPDATE[@]}"; do
    sed -i '' "/^$key[[:space:]]*=.*$/d" $ENV_FILE
done

echo "" >> $ENV_FILE
echo "AWS_ACCESS_KEY_ID=\"$AWS_KEY_ID\"" >> $ENV_FILE
echo "AWS_SECRET_ACCESS_KEY=\"$AWS_SECRET_KEY\"" >> $ENV_FILE
echo "S3_BUCKET_NAME=\"$S3_BUCKET\"" >> $ENV_FILE
echo "AWS_REGION=\"$AWS_REGION\"" >> $ENV_FILE
