FROM centos:centos6

RUN yum -y update && \
    yum -y install \
        make \
        shellcheck \
        gcc \
        yum-utils \
        builddep \
        python \
        wget \
        nano \
        git \
        openssh-server \
        openssh-clients && \
    \
    yum -y install \
        libtest-perl \
        perl-Test-Harness \
        perl-Test-Simple \
        perl-Test-Exception \
        perl-JSON perl-Perl-Critic && \
    \
    chkconfig sshd on && service sshd start && \

    wget https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tgz && \
    tar xf Python-3.5.3.tgz && \
    cd Python-3.5.3 && \
    ./configure && \
    make && \
    make install && \
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

WORKDIR /home/jenkins

COPY .ssh .ssh

RUN chmod 700 .ssh && \
    cd .ssh && \
    cat id_rsa.pub > authorized_keys && \
    chmod 600 authorized_keys && \
    chown -R jenkins:jenkins ../.ssh

EXPOSE 22 5000

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
