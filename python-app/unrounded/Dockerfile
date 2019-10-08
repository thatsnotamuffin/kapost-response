FROM amazonlinux:2018.03
MAINTAINER root
RUN yum -y update && \
    yum -y install python36 && \
    yum -y install python36-setuptools && \
    easy_install-3.6 pip && \
    pip3 install --upgrade pip && \
    pip3 install boto3 && \
    yum clean all
COPY s3_move_noround.py /
RUN chmod +x /s3_move_noround.py
ENTRYPOINT ["/s3_move_noround.py"]
CMD ["SourceS3Bucket", "DestinationS3Bucket", "MiBThreshold"]
