FROM java:8
MAINTAINER Cloud Fabric <cloud-fabric@medallia.com>

RUN apt-get update && apt-get install -y openjdk-8-jdk wget \
	python2.7 libsvn-dev libapr1-dev # Aurora dependencies

RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz | tar -xzf - -C /usr/share \
    && mv /usr/share/zookeeper-3.4.8 /usr/share/zookeeper \
    && mkdir -p /tmp/zookeeper

RUN wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.8/gosu-$(dpkg --print-architecture)" && chmod +x /usr/local/bin/gosu && gosu nobody true  && apt-get purge -y --auto-remove wget

 
ENV ZOO_LOG4J_PROP INFO,CONSOLE
ENV DATADIR /opt/zookeeper
ENV CLIENTPORT 2181
ENV INITLIMIT 5
ENV SYNCLIMIT 2
ENV CNXTIMEOUT 5000

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

VOLUME ["/opt/zookeeper", "/tmp/zookeeper"]

ADD run.sh /

ENTRYPOINT ["/run.sh"]
CMD ["start-foreground", "/opt/zookeeper/conf/zoo.cfg"]
