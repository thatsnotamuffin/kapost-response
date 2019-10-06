#!/bin/bash

# Global variables
bucket1="foo-test-python-script1"
bucket2="foo-test-python-script2"
threshold=2 # in MiB

# Command to grab all objects in bucket1
awsCommand="aws s3 ls --summarize --human-readable --recursive s3://$bucket1"
$awsCommand

# Store all objects in bucket1 in fileArray
fileArray=()
while IFS= read -r line ; do
  fileArray+=( "$line" )
done < <( $awsCommand | head -n -2 | grep MiB )

echo "${fileArray[@]}"

# Show all objects greater than or equal to threshold
s3Array=()
for i in "${fileArray[@]}" ; do
  objectSize=$(echo $i | awk '{print $3}')
  if [ $(echo "$objectSize>=$threshold" | bc) == 1 ] ;
    then
      file=$(echo $i | awk '{print $5}')
      s3Array+=( "$file" )
  fi
done

printf "\n\n"
echo "${s3Array[@]}"

# Copy items from bucket1 to bucket2
for item in "${s3Array[@]}" ; do
  aws s3 cp s3://$bucket1/$item s3://$bucket2
done

# Displaying results
echo "$bucket1 objects"
aws s3 ls --summarize --human-readable --recursive s3://$bucket1
printf "\n\n"

echo "$bucket2 objects"
aws s3 ls --summarize --human-readable --recursive s3://$bucket2
printf "\n\n"
