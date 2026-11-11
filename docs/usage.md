---
type: Usage
title: krateo-private-ca — usage
description: Install cert-manager without auto-approval, approver-policy and trust-manager, then this chart; request a certificate from the issuer and trust the published bundle.
resource: oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca
tags: [usage]
timestamp: 2026-11-11T00:00:00Z
---

# Usage

## Install order

```console
$ helm install cert-manager jetstack/cert-manager --version v1.21.3 -n cert-manager --create-namespace \
    --set crds.enabled=true --set disableAutoApproval=true
$ helm install approver-policy jetstack/cert-manager-approver-policy --version v0.29.0 -n cert-manager
$ helm install trust-manager jetstack/trust-manager --version v0.26.0 -n cert-manager \
    --set app.trust.namespace=cert-manager --set app.webhook.tls.approverPolicy.enabled=true
$ helm install private-ca oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca --version 0.1.0 \
    -n cert-manager -f values.yaml
```

One Helm release cannot carry a CRD and resources of its kind, so the dependencies are separate
releases. trust-manager's own webhook certificate needs approval too, which its
`app.webhook.tls.approverPolicy.enabled` provides.

## Consuming

A consumer creates a `Certificate` with `issuerRef: {kind: ClusterIssuer, name: krateo-private-ca}`
and only the DNS names its issuance entry allows. Clients mount the ConfigMap `<bundle.name>` key
`ca.crt` as their CA file.

## Measured (GKE, cert-manager v1.21.3, approver-policy v0.29.0, trust-manager v0.26.0)

| request | result |
|---|---|
| allowed name, allowed namespace | Approved by the issuance policy, issued |
| `evil.example.com`, allowed namespace | Denied (`spec.allowed.dnsNames.values`) |
| allowed name, other namespace | never approved (no policy selects it), never signed |
| leaf against the published bundle | `openssl verify` OK; the leaf carries an Authority Key Identifier |
| `maxDuration` set, Certificate without `spec.duration` | Denied (`spec.constraints.maxDuration: Invalid value: "nil"`) |
