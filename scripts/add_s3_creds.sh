#!/bin/bash

# Create the AWS credentials file based on environment variables
cat <<EOF > /home/kasm-user/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF
