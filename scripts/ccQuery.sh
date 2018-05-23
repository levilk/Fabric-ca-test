#!/bin/bash


source /scripts/env.sh

function main {
   if [ $# -ne 3 ]; then
      echo "Usage: ccQuery <peerORG> <peerNUM> <expected-value>"
   fi 
   initPeerVars $1 $2
   switchToUserIdentity
   chaincodeQuery $3
}


function chaincodeQuery {
   if [ $# -ne 1 ]; then
      echo "Usage: chaincodeQuery <expected-value>"
   fi
   set +e
   echo "Querying chaincode in the channel '$CHANNEL_NAME' on the peer '$PEER_HOST' ..."
   local rc=1
   local starttime=$(date +%s)
   # Continue to poll until we get a successful response or reach QUERY_TIMEOUT
   while test "$(($(date +%s)-starttime))" -lt "$QUERY_TIMEOUT"; do
      sleep 1
      peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}' >& log.txt
      VALUE=$(cat log.txt | awk '/Query Result/ {print $NF}')
      if [ $? -eq 0 -a "$VALUE" = "$1" ]; then
         echo "Query of channel '$CHANNEL_NAME' on peer '$PEER_HOST' was successful"
         set -e
         return 0
      fi
      echo -n "."
   done
   cat log.txt
   #cat log.txt >> $RUN_SUMFILE
   echo "Failed to query channel '$CHANNEL_NAME' on peer '$PEER_HOST'; expected value was $1 and found $VALUE"
}


main $1 $2 $3