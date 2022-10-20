# Proxy Scanner Helm Chart

Instructions for using HELM charts to deploy the Lacework Proxy Scanner.

## Proxy scanner configuration: 
More details can be found at https://support.lacework.com/hc/en-us/articles/1500004222981-Integrate-Proxy-Scanner
```
config:
  scan_public_registries: true
  static_cache_location: /opt/lacework
  lacework:
    account_name: 
    integration_access_token: 
  registries:
  registry_secret_name:
  - domain:
    name:
    ssl:
    auto_poll:
    is_public:
    auth_type:
    auth_header_name: Authorization
    credentials:
      user_name:
      password:
    notification_type:
    poll_frequency_minutes: 20
    disable_non_os_package_scanning: false
    go_binary_scanning:
      enable: false
      scan_directory_path: ""
```
## Using release packages

1. Download the latest release of the proxy-scanner from https://github.com/lacework/helm-charts

2. Edit values.yaml (~/lacework/helm/proxy-scanner/values.yaml) to update the config information as cited above. [Required]
      
3. To secure communication when used with the Lacework admission controller, 
   generate certs for this service and set the following values in values.yaml [Optional]
   ```   
   skipCert: false
   serverCertificate: "<base64_encoded_admission.crt>"
   serverKey: "<base64_encoded_admission.key>"
   ```
   Remember to keep the root CA cert carefully in order to populate that in Lacework admission controller settings.

4. Install proxy scanner
   cd lacework
   helm install -n lacework --create-namespace lacework-proxy-scanner ./helm/proxy-scanner

5. Display the pods for verification
   kubectl get pods -n lacework
   
## Adding helm repo
```
helm repo add lacework https://lacework.github.io/helm-charts 

helm upgrade --install --create-namespace --namespace lacework \
    --set certs.skipCert = true \
    --set certs.serverCertificate= ${SCANNER_CERT}\
    --set certs.serverKey= ${SCANNER_KEY}\
    --values values.yaml \
lacework-proxy-scanner lacework/proxy-scanner
```
Note:
Cert related fields are Optional.
You should pass base 64 encoded certs/keys you have or can generate using the script file in the repo
Values.yaml with the registry credentials as described above is MANDATORY.

## Configurable parameters

| Parameter                         | Description                                                                 | Default                   | Mandatory               |
| --------------------------------- | --------------------------------------------------------------------------- | ------------------------- | ----------------------- |
| `certs.skipCert`                  | Use https between Lacework Admission controller and scanner                 | `N/A`                     | `NO`                   |
| `certs.serverCertificate`         | Certificate for TLS authentication with the Admission controller            | `N/A`                     | `NO`                   |
| `certs.serverKey`                 | Certificate key for TLS authentication with the Admission controller        | `N/A`                     | `NO`                   |
| `config`                          | Registry credentials as specified in values.yaml                            | `N/A  `                   | `YES`                   |
| `ingress.enabled`                 | Ingress resource for webhook notification                                   | `false`                   | `NO`                    |

## Issues and feedback

If you encounter any problems or would like to give us feedback on this deployment, we encourage you to raise issues here on GitHub.