#!/bin/bash


source /scripts/env.sh

function main {
    if [ $# -ne 4 ]; then
      echo "Usage: instantinateCC <ordererORG> <ordererNUM> <peerORG> <peerNUM>"
      exit 1
    fi
    makePolicy
    initOrdererVars $1 $2
    initPeerVars $3 $4
    export ORDERER_PORT_ARGS="-o $ORDERER_HOST:7050 --tls --cafile $CA_CHAINFILE --clientauth"
    export ORDERER_CONN_ARGS="$ORDERER_PORT_ARGS --keyfile $CORE_PEER_TLS_CLIENTKEY_FILE --certfile $CORE_PEER_TLS_CLIENTCERT_FILE"
    peer chaincode instantiate -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "$POLICY" $ORDERER_CONN_ARGS
}


function makePolicy  {
   POLICY="OR("
   local COUNT=0
   for ORG in $PEER_ORGS; do
      if [ $COUNT -ne 0 ]; then
         POLICY="${POLICY},"
      fi
      initOrgVars $ORG
      POLICY="${POLICY}'${ORG_MSP_ID}.member'"
      COUNT=$((COUNT+1))
   done
   POLICY="${POLICY})"
   log "policy: $POLICY"
}

main $1 $2 $3 $4




#github.com/hyperledger/fabric-samples/chaincode/chaincode_example02/go



