
FROM ubuntu:trusty

RUN apt-get -y update && apt-get install -y openjdk-7-jre-headless wget zookeeperd
RUN echo manual > /etc/init/zookeeper.override

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

EXPOSE 2181 2888 3888

VOLUME ["/opt/zookeeper"]

ENTRYPOINT ["/usr/share/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground", "/opt/zookeeper/conf/zoo.cfg"]
