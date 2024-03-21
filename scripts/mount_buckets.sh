#!/bin/bash

set -e

# Directory for mounting S3 buckets
mkdir -p /home/kasm-user/projects


# Read S3 credentials and endpoints from environment variables
echo "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs


# Parse BUCKET_LIST and mount each bucket
# Assuming BUCKET_LIST is in the format "bucket1:/mount/point1;bucket2:/mount/point2"
IFS=';' read -ra ADDR <<< "$BUCKET_LIST"
for i in "${ADDR[@]}"; do
    # Split the bucket and mount point
    IFS=':' read -ra BUCKET_MOUNT <<< "$i"
    BUCKET=${BUCKET_MOUNT[0]}
    MOUNT_POINT=${BUCKET_MOUNT[1]}
    
    # assert directory structure
    mkdir -p $MOUNT_POINT
    # Mount using s3fs
    s3fs $BUCKET $MOUNT_POINT -o _netdev,allow_other,use_path_request_style,url=${S3_ENDPOINT},passwd_file=/etc/passwd-s3fs -o nonempty
done
