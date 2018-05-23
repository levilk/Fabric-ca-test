#!/bin/bash


source /scripts/env.sh

function main {
  if [ $# -ne 2 ]; then
      echo "Usage: installCC <peerORG> <peerNUM>"
      exit 1
  fi
  initOrgVars $1
  initPeerVars $1 $2
  installChaincode
}


function installChaincode {
   switchToAdminIdentity
   echo "Installing chaincode on $PEER_HOST ..."
   peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric-samples/chaincode/chaincode_example02/go
}


# Install chaincode on all peer in all orgs
#for ORG in $PEER_ORGS; do
#    initOrgVars $ORG
#    COUNT=1
#    while [[ "$COUNT" -le $NUM_PEERS ]]; do
#      initPeerVars $ORG $COUNT
#      installChaincode
#      COUNT=$((COUNT+1))
#   done
#done


main $1 $2