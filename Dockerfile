FROM centos:7.4.1708

# Update to last version
ARG zk_source_file="http://mirrors.ukfast.co.uk/sites/ftp.apache.org/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz"
RUN yum -y install net-tools \
java-1.8.0-openjdk \
wget \
unzip \
tar \
&& yum clean all
RUN wget $zk_source_file -P /tmp
RUN tar -xzvf /tmp/zookeeper-*.gz -C /
RUN rm /tmp/zookeeper-*.gz
RUN mv /zookeeper-* /zookeeper
RUN groupadd zookeeper
RUN useradd -g zookeeper -d /zookeeper -s /sbin/nologin zookeeper
RUN mkdir /data
RUN chown -R zookeeper:zookeeper /zookeeper/*
COPY zoo.cfg /zookeeper/conf/zoo.cfg
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
COPY entrypoint.sh /
EXPOSE 2181 2888 3888
ENTRYPOINT ["/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
