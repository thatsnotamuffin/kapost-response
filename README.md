README.md

This Repository contains a docker image and container to move objects over a given file size in MiB between 2 S3 buckets.
This has not been tested in other environments aside from the environment specified below.

EC2 Environment:
AWS EC2 instance - Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-00eb20669e0990cb4

Requirements:
IAM Role attached to EC2 instance
  - Permissions
    - AmazonS3FullAccess
Linux with access to /bin/bash

The scripts directory contains a setup_script.sh that installs all of the dependencies on to the system in order to use the repo and set up the docker container as well as a run_me.sh script to do the build and container creation/run
  - setup_script.sh
    - Installs
      - Python 3.6
      - Python 3.6 Setup Tools
      - Python 3.6 pip
      - AWS CLI
      - Docker
      - Git
    - Starts the Docker service
    - Prompts the user for a username to add to the Docker group
    - If the user is logged in, the user will need to re-login in order to ensure the group changes are complete
  - run_me.sh
    - Requires an argument of build or run
    - Entering 'build' will build the docker image
    - Entering 'run' will prompt the user for the source and destination S3 buckets as well as a threshold
      - Before performing the 'docker run' the script will check if the specified container 'thatsnotamuffin' is already running and if so, it will remove it

The app directory contains the necessary Dockerfile and s3_object_move.sh script to move objects between S3 buckets
  - s3_object_move.sh takes 3 arguments
    - bucket1 - source bucket for files to be moved from if they exceed the threshold
    - bucket2 - destination bucket for files to be moved to if they exceed the threshold
    - threshold - target file size in MiB
  - Dockerfile
    - Uses the amazonlinux 2018.03 image
    - Installs many of the same dependencies as the setup_script.sh
    - Creates an ec2-user directory in /home
    - Creates an app directory in /home/ec2-user

