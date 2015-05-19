# Docker image to start a Zookeeper node

Starts Zookeeper, by default getting the configuration present in /opt/zookeeper/conf/zoo.cfg

    docker run -t -v /foo/zookeeper:/opt/zookeeper medallia/zookeeper start-foreground /etc/zookeeper.cfg


