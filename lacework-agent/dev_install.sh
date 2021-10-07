#!/bin/bash

set -euo pipefail

helm upgrade --install --create-namespace -f values.yaml \
             --set image.pullPolicy=Never \
             --set image.tag=${VERSION:-99.9.9} \
             --set laceworkConfig.accessToken=${LACEWORK_AGENT_TOKEN} \
             --set laceworkConfig.serverUrl=${LACEWORK_SERVER_URL} \
             --set laceworkConfig.env=${USER}-minikube \
             --set laceworkConfig.kubernetesCluster=${USER}-minikube \
             lacework-agent .
