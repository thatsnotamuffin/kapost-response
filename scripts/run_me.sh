#!/bin/bash

## This script is to simplify the build and run process because lazy

# Global
target=$1

# Ensure correct input
if [ $# -eq 0 ] ;
  then
    echo "No arguments provided. Please enter build or run.."
    exit 1;
fi

if [ $target != "build" ] && [ $target != "run" ] ;
  then
    echo "Invalid argument provided. Please enter build or run.."
    exit 1;
fi

# Do the build thing
if [ $target == "build" ] ;
  then
    echo "Doing the build thing.."
    docker build -t s3-object-move ../app/
fi

# Do the run thing
if [ $target == "run" ] ;
  then
    read -p "Source S3 Bucket: " sourceBucket
    read -p "Destination S3 Bucket: " destinationBucket
    read -p "Threshold in MiB: " threshold

    # Check for existence of thatsnotamuffin container and remove it
    muffinExists=$(docker container ls -a | grep thatsnotamuffin | wc -l)
    if [ $muffinExists -ge 1 ] ;
      then
        docker container rm thatsnotamuffin
    fi
    
    # Start the docker container
    docker run --name thatsnotamuffin -d s3-object-move $sourceBucket $destinationBucket $threshold
fi

