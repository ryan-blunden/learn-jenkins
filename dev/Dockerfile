FROM centos:centos6

RUN yum -y update && \
    yum -y install wget nano openssh-clients && \
    \
    wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm && \
    yum -y install /tmp/jdk-8-linux-x64.rpm && \
    \
    yum clean all

WORKDIR /usr/src/app

EXPOSE 8080

CMD ["bash"]
