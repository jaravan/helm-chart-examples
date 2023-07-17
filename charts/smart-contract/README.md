# Deploy Smart Contracts

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A helmchart to deploy Smart Contracts to an RPC node

## Sample installation commands:

```bash
helm upgrade --install deploysc charts/smart-contract \
    --namespace=sc --create-namespace \
    --values my-values.yaml
```

```yaml
# my-values.yaml
args:
  # Account private key to use for deploying the Smart Contracts (without the prefix '0x')
  accountPrivateKey: "055cabd34e9fd50b974192892ed1c8cb64e71b0b779763c850e93562c2f4be5e" 
  # Blockchain node RPC URL
  rpcURL: "http://quorum-rpc.quorum:8545"

smartContractFiles:
  - name: "HelloWorld.sol"
    sourceCode: |-
      // SPDX-License-Identifier: MIT
      // compiler version must be greater than or equal to 0.8.0 and less than 0.9.0
      pragma solidity ^0.8.0;

      contract HelloWorld {
          string public greet = "Hello World!";
      }
```

```bash
helm upgrade --install deploysc charts/smart-contract \
  --set "args.accountPrivateKey=70ad6ce6f441dceb0ad434ede06442391dbebff8c9f90abaab714e90023d61e9" \
  --set "smartContractFiles[0].name='sc1.sol'" \
  --set-file "smartContractFiles[0].sourceCode=sc1.sol" \
  --set "smartContractFiles[1].name='sc2.sol'" \
  --set-file "smartContractFiles[1].sourceCode=sc2.sol"
```

```bash
helm upgrade --install deploysc charts/smart-contract \
  --set "args.accountPrivateKey=70ad6ce6f441dceb0ad434ede06442391dbebff8c9f90abaab714e90023d61e9,smartContractFiles[0].name='sc1.sol',smartContractFiles[0].sourceCode=$(cat sc1.sol)"
```

## Resolution of execution of command `kubectl create/apply` within container

Due to the fact that there is an error when executing `kubectl create` inside the container we use the following workarounds for creating the configmap required for writing the deployed smartcontracts info:

1. We either remove the create verb from the role and create the `configmap-sc-info.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "smart-contract.configMapNameSmartContractInfo" . }}
  namespace: {{ template "smart-contract.namespace" . }}
  annotations:
    "description": "Deployed Smart Contracts info"
  labels:
    {{- include "smart-contract.labels" . | nindent 4 }}
```

2. OR remove the resourceName from the role and add the verb create:

```yaml
  resourceNames:
  - {{ include "smart-contract.configMapNameSmartContractInfo" . | quote }}
```