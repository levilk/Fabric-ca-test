#!/bin/bash


SDIR=$(dirname "$0")
source $SDIR/env.sh


# Enroll the CA administrator
function enrollCAAdmin {
   export FABRIC_CA_CLIENT_HOME=$HOME/cas/$CA_NAME
   export FABRIC_CA_CLIENT_TLS_CERTFILES=$CA_CHAINFILE
   fabric-ca-client enroll -d -u https://$CA_ADMIN_USER_PASS@$CA_HOST:7054
}

# Register any identities associated with a peer
function registerPeerIdentities {
      initOrgVars $1
      enrollCAAdmin
      initPeerVars $1 $2
      fabric-ca-client register -d --id.name $PEER_NAME --id.secret $PEER_PASS --id.type peer
}


#registerPeer <ORG> <NUM>
registerPeerIdentities $1 $2 