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
    read -p "Do you want to round the byte count up as shown in AWS S3? y or n " roundConfirm
    if [ $roundConfirm != "y" ] && [ $roundConfirm != "n" ] ;
      then
        echo "Invalid response. Please enter y or n. Exiting..."
        exit 1;
    elif [ $roundConfirm == "y" ] ;
      then
        echo "Doing the build thing.."
        docker build -t s3-object-move-rounded ../rounded
    else
      echo "Doing the build thing.."
      docker build -t s3-object-move-unrounded ../unrounded
    fi
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

    # Starting the container - rounded or unrounded depending on user input
    read -p "Do you want to round the byte count up as shown in AWS S3? y or n " roundConfirm
    if [ $roundConfirm != "y" ] && [ $roundConfirm != "n" ] ;
      then
        echo "Invalid response. Please enter y or n. Exiting..."
        exit 1;
    elif [ $roundConfirm == "y" ] ;
      then
        docker run --name thatsnotamuffin -d s3-object-move-rounded $sourceBucket $destinationBucket $threshold
    else
      docker run --name thatsnotamuffin -d s3-object-move-unrounded $sourceBucket $destinationBucket $threshold
    fi
fi

