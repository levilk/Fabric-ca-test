#!/bin/bash


source /scripts/env.sh



# Revokes the fabric user
function revokeFabricUserAndGenerateCRL {
   switchToAdminIdentity
   export  FABRIC_CA_CLIENT_HOME=$ORG_ADMIN_HOME
   echo "Revoking the user '$USER_NAME' of the organization '$ORG' with Fabric CA Client home directory set to $FABRIC_CA_CLIENT_HOME and generating CRL ..."
   export FABRIC_CA_CLIENT_TLS_CERTFILES=$CA_CHAINFILE
   fabric-ca-client revoke -d --revoke.name $USER_NAME --gencrl
}



revokeFabricUserAndGenerateCRL