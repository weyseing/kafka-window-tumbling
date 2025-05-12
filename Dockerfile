# base image
FROM confluentinc/cp-server-connect-base:7.9.0

# worker dir, user
WORKDIR /connect
USER root

# copy file
COPY . /connect

# install dependencies
RUN yum update -y && \
    yum install -y curl jq vim && \
    yum clean all && \
    rm -rf /var/cache/yum

# install plugins
RUN confluent-hub install --no-prompt debezium/debezium-connector-mysql:2.2.1 && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.4 && \
    confluent-hub install --no-prompt confluentinc/connect-transforms:1.4.5 

# install python packages
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt