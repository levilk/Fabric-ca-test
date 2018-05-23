#!/bin/bash


source /scripts/env.sh


# Switch to the current org's admin identity.  Enroll if not previously enrolled.
function switchToAdminIdentity {
   export FABRIC_CA_CLIENT_HOME=$ORG_ADMIN_HOME
   export FABRIC_CA_CLIENT_TLS_CERTFILES=$CA_CHAINFILE 
   if [ ! -d $ORG_ADMIN_HOME ]; then
      echo "Enrolling admin '$ADMIN_NAME' with $CA_HOST ..."
      fabric-ca-client enroll -d -u https://$ADMIN_NAME:$ADMIN_PASS@$CA_HOST:7054
      # If admincerts are required in the MSP, copy the cert there now and to my local MSP also
      if [ $ADMINCERTS ]; then
         mkdir -p $(dirname "${ORG_ADMIN_CERT}")
         cp $ORG_ADMIN_HOME/msp/signcerts/* $ORG_ADMIN_CERT
         mkdir $ORG_ADMIN_HOME/msp/admincerts
         cp $ORG_ADMIN_HOME/msp/signcerts/* $ORG_ADMIN_HOME/msp/admincerts
      fi
   fi
   export CORE_PEER_MSPCONFIGPATH=$ORG_ADMIN_HOME/msp
}

switchToAdminIdentity 