########################################
# Build package
########################################

FROM maven:3.5 as builder

WORKDIR /home/builder
COPY . .
RUN mvn clean package -Dmaven.test.skip=true

########################################
# Build prod image
########################################

FROM centos:6

RUN yum update -y && \
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
    yum clean all

# Set environment variables.
ENV HOME /root

# Get the JAR file 
COPY --from=builder /home/builder/target/clamav-rest-1.0.2.jar /var/clamav-rest/
COPY bootstrap.sh /

# Open up the server 
EXPOSE 8200

CMD ["/bootstrap.sh"]

