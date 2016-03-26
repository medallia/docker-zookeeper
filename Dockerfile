
FROM java:8

RUN apt-get update && apt-get install -y openjdk-8-jdk wget \
	python2.7 libsvn-dev libapr1-dev # Aurora dependencies

RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzf - -C /usr/share \
    && mv /usr/share/zookeeper-3.4.6 /usr/share/zookeeper \
    && mkdir -p /tmp/zookeeper

ENV ZOO_LOG4J_PROP INFO,CONSOLE

EXPOSE 2181 2888 3888

RUN mkdir /opt/zookeeper
RUN mkdir /opt/zookeeper/conf
ADD /conf/zoo.cfg /opt/zookeeper/conf/zoo.cfg

WORKDIR /opt/zookeeper

VOLUME ["/opt/zookeeper", "/tmp/zookeeper"]

ENTRYPOINT ["/usr/share/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground", "/opt/zookeeper/conf/zoo.cfg"]

