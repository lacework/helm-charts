#!/bin/bash

set -euo pipefail

helm repo add lacework https://lacework.github.io/helm-charts/
helm upgrade --install --create-namespace --namespace lacework \
             --set laceworkConfig.accessToken=${LACEWORK_AGENT_TOKEN} \
             --set laceworkConfig.serverUrl=${LACEWORK_SERVER_URL} \
             --set laceworkConfig.env=${USER}-minikube \
             --set laceworkConfig.clustername=${USER}-minikube \
             lacework-agent lacework/lacework-agent
