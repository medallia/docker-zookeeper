# Docker image to start a Zookeeper  node

Starts Zookeeper, creates  /opt/zookeeper/conf/zoo.cfg and /opt/zookeeper/myid with parameters passed through environment variables.
The script will calculate myid based on the local ip address and position in the ZK_HOST string.
Environment variables have defaults, only ZK_HOSTS is required.

    docker run -t -v /foo/zookeeper:/opt/zookeeper \ 
       -e DATADIR=/opt/zookeeper \
       -e CLIENTPORT=2181 \
       -e INITLIMIT=5 \
       -e SYNCLIMIT=2 \
       -e CNXTIMEOUT=5000 \
       -e ZK_HOSTS=192.168.255.31:2181,192.168.255.32:2181,192.168.255.33 \
       medallia/zookeeper start-foreground /etc/zookeeper.cfg

___________________________________________________
*Copyright 2016 Medallia Inc. All rights reserved*
