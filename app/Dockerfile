FROM amazonlinux:2018.03
MAINTAINER ec2-user

# Install dependencies
RUN yum -y update && \
    yum -y install python36 && \
    yum -y install python36-setuptools && \
    yum -y install bc && \
    easy_install-3.6 pip && \
    pip3 install awscli --upgrade

# Configure stuff
RUN mkdir /home/ec2-user && \
  mkdir /home/ec2-user/app
COPY $HOME/s3_object_move.sh /home/ec2-user/app
RUN chmod +x /home/ec2-user/app/s3_object_move.sh

# Run s3_object_move.sh script
ENTRYPOINT ["/home/ec2-user/app/s3_object_move.sh"]
CMD ["null", "null", "null"]

