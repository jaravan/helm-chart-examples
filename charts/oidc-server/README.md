# OIDC Server

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)


```bash
helm upgrade --install oidcsrv oidc-server/ \
    --namespace=sso --create-namespace \
    --values sbx-oidc-config.yaml
```