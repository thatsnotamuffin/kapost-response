#!/bin/bash

# Global Variables
bucket1=$1
bucket2=$2
threshold=$3

# Command to grab all objects in bucket1
awsCommand="aws s3 ls --summarize --human-readable --recursive s3://$bucket1"

# Store all objects in bucket1 in fileArray
fileArray=()
while IFS= read -r line ; do
  fileArray+=( "$line" )
done < <( $awsCommand | head -n -2 | grep MiB )

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

# Copy items from bucket1 to bucket2
for item in "${s3Array[@]}" ; do
  aws s3 cp s3://$bucket1/$item s3://$bucket2
  aws s3api delete-object --bucket $bucket1 --key $item
done

# Displaying results
printf "\n\n"
echo "$bucket1 objects"
aws s3 ls --summarize --human-readable --recursive s3://$bucket1
printf "\n\n"

echo "$bucket2 objects"
aws s3 ls --summarize --human-readable --recursive s3://$bucket2
printf "\n\n"

