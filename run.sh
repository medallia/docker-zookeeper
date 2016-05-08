#!/bin/bash
set -e
set -x

NET_IP="$(ip route get 8.8.8.8| head --lines 1 | sed -r -e 's/.+src ([^ ]+).*$/\1/')"

if [[ -z $DATADIR || -z $ZK_HOSTS ]]; then
    echo "Missing parameters"
    exit 1
fi

IFS=',' read -a HOSTS <<< "${ZK_HOSTS}"

mkdir -p $DATADIR/conf
chmod -R a+rwx $DATADIR/conf

cat > $DATADIR/conf/zoo.cfg << EOF
tickTime=2000
dataDir=${DATADIR}
clientPort=${CLIENTPORT}
initLimit=${INITLIMIT}
syncLimit=${SYNCLIMIT}
cnxTimeout=${CNXTIMEOUT}
EOF

counter=1
MY_ID=""
for i in "${HOSTS[@]}"; do 
  IFS=: read -r ip port <<< $i 
  echo "server.$counter=${ip}:2888:3888" >> $DATADIR/conf/zoo.cfg
  if [ "$ip" = "$NET_IP" ]; then
      MY_ID=$counter
  fi
  (( counter ++ ))
done

cat > $DATADIR/myid << END
$MY_ID
END

exec /usr/share/zookeeper/bin/zkServer.sh "$@"