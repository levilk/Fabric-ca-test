#!/bin/bash


source /scripts/env.sh


function main {
 if [ $# -ne 2 ]; then
      echo "Usage: ccInvoke <peerORG> <peerNUM>"
 fi 
   initPeerVars $1 $2
   switchToUserIdentity
   echo "Sending invoke transaction to $PEER_HOST ..."
   peer chaincode invoke -C $CHANNEL_NAME -n mycc -c '{"Args":["invoke","a","b","20"]}' $ORDERER_CONN_ARGS
}
  
main $1 $2