# azure-app-proxy

## Prerequisites

App Admin in local tenant
license?

## Installing app proxy

## Configuring app proxy

## Features to be implemented

- [ ] SSL certificate
- [ ] DNS to read from yaml file
- [x] Schema for yaml file
- [ ] Possibly allow setting boolean values on per app basic if required
- [ ] README
- [ ] Move to own repo?
- [ ] Tests
- [ ] CI/CD
- [ ] Publish to npm registry
- [x] Linting
- [ ] Blog
- [x] Logo
- [] Visible to users


### Notes

SSL certificate
https://github.com/hmcts/cvp-audio-ingress/blob/8b53ce29176e7aa515f5d4b30318f5909d89a288/terraform/cloudconfig/cloudconfig.tpl#L890

https://learn.microsoft.com/en-us/graph/api/resources/onpremisespublishing?view=graph-rest-beta
https://learn.microsoft.com/en-us/graph/api/resources/keycredential?view=graph-rest-beta

```json
{
  "onPremisesPublishing": {
    "verifiedCustomDomainKeyCredential": {
      "type": "X509CertAndPassword",
      "keyId": "",
      "value": [
        "byte array"
      ]
    },
    "verifiedCustomDomainPasswordCredential": {
      "value": "Password12"
    }
  }
}
```
