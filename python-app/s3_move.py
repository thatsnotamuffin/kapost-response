#!/usr/bin/env python36

# Import libraries
import boto3
import sys

# Connect S3
s3 = boto3.resource('s3')
s3Client = boto3.client('s3')

# Variables
bucket1 = s3.Bucket(sys.argv[1])
destinationBucket = s3.Bucket(sys.argv[2])
threshold = sys.argv[3]
sourceBucket = sys.argv[1]

# Find all objects in argument 1 / source bucket
for file in bucket1.objects.all():
    fileSize = s3Client.head_object(
        Bucket=sourceBucket,
        Key=file.key
    )
    byteIn = file.size
    megabyteFile = ((byteIn / 1024) / 1024)
    if (megabyteFile >= int(threshold)):
        copy_source = {
            'Bucket': sourceBucket,
            'Key': file.key
        }
        destinationBucket.copy(copy_source, file.key)
        deleteObject = s3.Object(sourceBucket, file.key)
        deleteObject.delete()

