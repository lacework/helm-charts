# Admission Controller Helm Chart

## Disclaimer: This is an Alpha Release, for internal use only
Contact Lacework Support to be enrolled in the Beta program

## Instructions for using HELM charts to deploy the Lacework Admission Controller.

## Using release packages

1. Download the latest release of the Admission Controller from https://github.com/lacework/helm-charts

2. Extract the admission-controller-*.tar.gz file
tar -xvf admission-controller-*.tar.gz --directory ~/lacework/.

3. Generate certificates: Skip 3a if you are using your own certs
   a. Generate these certificates by executing the script:
   cd lacework/helm/admission-controller
   ./generate-certs.sh
   Encode the certificates into base64 for ca.crt, admission.crt and admission.key using this command:
   cat <file-name> | base64 | tr -d '\n'
   
   b. Provide the certificates previously obtained in the fields of the values.yaml file
   ```
   certs:
   name: lacework-admission-certs
   serverCertificate: "<base64_encoded_admission.crt>"
   serverKey: "<base64_encoded_admission.key>"
   webhooks:
   caBundle: "<base64_encoded_ca.crt>"
   ```

4. Update proxy scanner settings if required - port, skipVerify, caCert according to definitions provided below

5. Install Validating webhook in the cluster
cd lacework
helm install -n lacework --create-namespace lacework-admission-controller ./helm/admission-controller

6.  Display the pods for verification
kubectl get pods -n lacework-dev
    
## Adding helm repo
```
helm repo add lacework https://lacework.github.io/helm-charts 

helm upgrade --install --create-namespace --namespace lacework \
   --set webhooks.caBundle= ${WEBHOOK_ROOT_CA} \
   --set certs.serverCertificate= ${WEBHOOK_SERVER_CERT}\
   --set certs.serverKey= ${WEBHOOK_SERVER_KEY}\
   --set scanner.caCert= ${SCANNER_ROOT_CA}\
lacework-admission-controller lacework/admission-controller
```
Note: the above should be base 64 encoded certs/keys you have or generate using the script above
scanner.caCert is used for SSL between Admission webhook and scanner

## Configurable parameters

| Parameter                         | Description                                                                 | Default                   | Mandatory               |
| --------------------------------- | --------------------------------------------------------------------------- | ------------------------- | ----------------------- |
| `logger.debug           `         | Set to enable debug logging                                                 | `false`                   | `YES`                   |
| `certs.name`                      | Secret name for Helios certs                                                | `helios-admission-certs`  | `YES`                   |
| `certs.serverCertificate`         | Certificate for TLS authentication with the Kubernetes api-server           | `N/A`                     | `YES`                   |
| `certs.serverKey`                 | Certificate key for TLS authentication with the Kubernetes api-server       | `N/A`                     | `YES`                   |
| `webhooks.caBundle`               | Root certificate for TLS authentication with the Kubernetes api-server      | `N/A`                     | `YES`                   |
| `policy.block_exec   `            | Set to enable deployment/pod block based on violation                       | `false`                   | `YES`                   |
| `policy.bypass_scope`             | CSV of namespaces to bypass                                                 | `kube-system,kube-public,lacework,lacework-dev`     | `YES`                   |
| `nodeSelector`                    | Kubernetes node selector                                                    | `{}`                      | `NO`                    |
| `scanner.server`                  | Lacework proxy scanner name                                                 | ``                        | `YES`                   |
| `scanner.namespace`               | Namespace in which it is deployed                                           | ``                        | `YES`                   |
| `scanner.skipVerify`              | SSL between the webhook and the scanner                                     | `true`                    | `NO`                    |
| `scanner.caCert`                  | Root cert of scanner                                                        | `N/A`                     | `YES`                   |
| `scanner.timeout`                 | Context deadline timeout                                                    | `30`                      | `NO`                    |


## Issues and feedback

If you encounter any problems or would like to give us feedback on this deployment, we encourage you to raise issues here on GitHub.