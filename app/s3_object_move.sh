#!/bin/bash

# Global variables
bucket1="foo-test-python-script1"
bucket2="foo-test-python-script2"
threshold=2

# Command to grab all objects in bucket1
awsCommand="aws s3 ls --summarize --human-readable --recursive s3://$bucket1"
$awsCommand

# Store all objects in bucket1 in fileArray
fileArray=()
while IFS= read -r line ; do
  fileArray+=( "$line" )
done < <( $awsCommand | head -n -2 | grep MiB )

echo "${fileArray[@]}"
