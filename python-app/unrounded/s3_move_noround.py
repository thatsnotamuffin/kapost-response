#!/usr/bin/env python36

# Import libraries
import boto3
import sys
import math

# Connect S3
s3 = boto3.resource('s3')
s3Client = boto3.client("s3")

# Set variables
bucket1 = s3.Bucket(sys.argv[1])
destinationBucket = s3.Bucket(sys.argv[2])
threshold = sys.argv[3]
sourceBucket = sys.argv[1]

# Check for objects over the specified threshold, move them to the destination bucket, and delete them from the source bucket
# This is done in megabytes, unrounded. For a rounded version, please use the other python app, s3_move.py
for file in bucket1.objects.all():
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
