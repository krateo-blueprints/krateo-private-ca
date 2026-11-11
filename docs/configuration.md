---
type: Configuration
title: krateo-private-ca — configuration
description: The values surface: the CA, cert-manager's service account, the issuance entries, the optional maximum duration, the bundle, and the trust namespace.
resource: oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca
tags: [configuration]
timestamp: 2026-11-11T00:00:00Z
---

# Configuration

| value | default | meaning |
|---|---|---|
| `ca.name` | `krateo-private-ca` | the ClusterIssuer, the CA Certificate and its Secret |
| `ca.commonName` / `duration` / `renewBefore` | `Krateo Private CA` / `87600h` / `720h` | |
| `ca.privateKey.{algorithm,size}` | `ECDSA` / `256` | |
| `certManager.serviceAccount.{name,namespace}` | `cert-manager` / `cert-manager` | the requester the policies are granted to |
| `issuance[]` | `[]` | `{name, namespaces[], dnsNames[]}`: one policy each; empty signs nothing |
| `maxDuration` | `""` | optional bound; when set, consumers' Certificates must set `spec.duration` |
| `bundle.{enabled,name,key,namespaces[]}` | `true`, `krateo-private-ca`, `ca.crt`, `[]` | the published ConfigMap |
| `trustNamespace` | `cert-manager` | trust-manager's trust namespace; must equal the release namespace |
