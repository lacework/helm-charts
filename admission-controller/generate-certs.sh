#!/bin/bash

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 100000 -out ca.crt -subj "/CN=admission_ca"

cat >admission.conf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ alt_names ]
DNS.1 = lacework-admission-controller.lacework.svc
DNS.2 = lacework-admission-controller.lacework.svc.cluster.local
DNS.3 = admission.lacework-dev.svc
DNS.4 = admission.lacework-dev.svc.cluster.local
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = @alt_names
EOF

openssl genrsa -out admission.key 2048
openssl req -new -key admission.key -out admission.csr -subj "/CN=lacework-admission-controller.lacework.svc" -config admission.conf
openssl x509 -req -in admission.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out admission.crt -days 100000 -extensions v3_req -extfile admission.conf