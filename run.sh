#!/bin/bash
set -e
set -x

NET_IP="$(ip route get 8.8.8.8| head --lines 1 | sed -r -e 's/.+src ([^ ]+).*$/\1/')"

if [[ -z $ZK_HOSTS ]]; then
    echo "Missing ZK_HOSTS parameter"
    exit 1
fi

IFS=',' read -a HOSTS <<< "${ZK_HOSTS}"

mkdir -p ${CONFDIR}

mkdir -p ${DATADIR}

mkdir -p ${LOGDIR}

cat > ${CONFDIR}/zoo.cfg-temp << EOF
tickTime=2000
dataDir=${DATADIR}
dataLogDir=${LOGDIR}
clientPort=${CLIENTPORT}
initLimit=${INITLIMIT}
syncLimit=${SYNCLIMIT}
cnxTimeout=${CNXTIMEOUT}
EOF

counter=1
MY_ID=""
for i in "${HOSTS[@]}"; do 
  IFS=: read -r ip port <<< $i 
  echo "server.$counter=${ip}:2888:3888" >> ${CONFDIR}/zoo.cfg-temp
  if [ "$ip" = "$NET_IP" ]; then
      MY_ID=$counter
  fi
  (( counter ++ ))
done

if [[ -z $MY_ID ]]; then
    echo "Cannot find $NET_IP in $ZK_HOSTS"
    exit 1
fi

cat > $DATADIR/myid << END
$MY_ID
END

mv ${CONFDIR}/zoo.cfg-temp ${CONFDIR}/zoo.cfg

exec /usr/share/zookeeper/bin/zkServer.sh "$@"