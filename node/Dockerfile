FROM centos:centos6

RUN yum -y update && \
    yum -y install wget nano openssh-server openssh-clients && \    
    \
    chkconfig sshd on && service sshd start && \
    \ 
    wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm && \
    yum -y install /tmp/jdk-8-linux-x64.rpm && \
    \
    yum clean all

ENV JAVA_HOME /usr/java/latest    

# Jenkins is run with user `jenkins`, uid = 1000
# This is because uid 1000 is almost always the first non-system user and will most likely match the host user uid.
RUN groupadd -g 1000 jenkins && \
    useradd -d "/home/jenkins" -u 1000 -g 1000 -m -s /bin/bash jenkins && \
    mkdir /home/jenkins/node && \
    chown jenkins:jenkins /home/jenkins/node

USER jenkins 

WORKDIR /home/jenkins

RUN mkdir -p ~/.ssh && \
    chmod 700 .ssh && \
    cd ~/.ssh && \
    ssh-keygen -t rsa -b 4096 -f id_rsa -N "" -C "node@jenkins" && \
    cat id_rsa.pub > authorized_keys && \
    chmod 600 authorized_keys && \
    cat id_rsa

USER root

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
