#!/bin/bash

########################
# include the magic
########################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${DIR}/resources/demo-magic.sh

# secret setup
mkdir -p /tmp/demo/extremely-basic-node-app
cp -r ~/workspace/apps/extremely-basic-node-app/* /tmp/demo/extremely-basic-node-app/
cd /tmp/demo

# hide the evidence
clear

# put your stuff here
BROKER_URL=http://$(cf app overview-broker-cf-summit | awk '/urls:/{ print $2 }')
pe "cf apps"
pe "open '${BROKER_URL}'"
p "clear"
pe "cf marketplace"
p "clear"
pe "cf create-service-broker overview-broker-cf-summit admin password ${BROKER_URL}"
pe "cf enable-service-access overview-broker-cf-summit"
p "clear"
pe "cf marketplace"
p "clear"
pe "cf create-service overview-broker-cf-summit simple my-service"
pe "cf services"
p "clear"
pe "cf apps"
pe "cf bind-service extremely-basic-node-app my-service"
pe "cf restart extremely-basic-node-app"
p "clear"
pe "cf env extremely-basic-node-app"
p "clear"
pe "cf unbind-service extremely-basic-node-app my-service"
pe "cf delete-service -f my-service"
