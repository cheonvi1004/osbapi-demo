#!/bin/bash

########################
# include the magic
########################
. scripts/resources/demo-magic.sh

#GET the address of the controller
SVC_CAT_API=$(minikube service -n catalog catalog-catalog-apiserver --url | sed -n 1p)
echo $SVC_CAT_API

#CREATE a new kubectl context
kubectl config set-cluster service-catalog --server=$SVC_CAT_API
kubectl config set-context service-catalog --cluster=service-catalog

# hide the evidence
clear

# put your stuff here
#SEE no broker has yet been registered
pe "kubectl --context=service-catalog get brokers,serviceclasses,instances,bindings"

#REGISTER a broker - we will use the earlier deployed regis
pe "cat resources/overview-broker.yaml"
pe "kubectl --context=service-catalog create -f resources/overview-broker.yaml"

#GET the service class for the resources/overview-broker service
#This shows details of the service and plans available
pe "kubectl --context=service-catalog get serviceclasses"
pe "kubectl --context=service-catalog get serviceclass resources/overview-broker -o yaml"

#CREATE a namespace for development
#All of our service instances and bindings will live here
pe "kubectl create ns development"

# #CREATE a service instance on the default plan
pe "cat resources/overview-instance.yaml"
pe "kubectl --context=service-catalog create -f resources/overview-instance.yaml"

#GET the service instance
pe "kubectl --context=service-catalog -n development get instances"
pe "kubectl --context=service-catalog -n development get instances -o yaml"

#CREATE a binding to the instance
pe "cat resources/overview-binding.yaml"
pe "kubectl --context=service-catalog create -f resources/overview-binding.yaml"

#GET the service binding
pe "kubectl --context=service-catalog -n development get binding"
pe "kubectl --context=service-catalog -n development get binding  -o yaml"

#GET the secret
pe "kubectl get secrets -n development"
pe "kubectl get secrets -n development resources/overview-credentials -o yaml"

#DELETE the binding
pe "kubectl --context=service-catalog -n development get binding"
pe "kubectl --context=service-catalog -n development delete binding resources/overview-binding"

#SEE binding and secret has gone
pe "kubectl --context=service-catalog -n development get binding"
pe "kubectl get secrets -n development"

#DELETE the instance
pe "kubectl --context=service-catalog -n development delete binding resources/overview-binding"
