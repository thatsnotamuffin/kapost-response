#!/usr/bin/env python36

# Import libraries
import boto3
import sys

# Connect S3
s3 = boto3.resource('s3')
s3Client = boto3.client('s3')

# List S3 Buckets
for bucket in s3.buckets.all():
    print(bucket.name)

# Variables
bucket1 = s3.Bucket(sys.argv[1])
destinationBucket = s3.Bucket(sys.argv[2])
threshold = sys.argv[3]
sourceBucket = sys.argv[1]

# Find all objects in argument 1 / source bucket
for file in bucket1.objects.all():
    print(file.key)
    fileSize = s3Client.head_object(
        Bucket=sourceBucket,
        Key=file.key
    )
    print(fileSize['ContentLength'])

