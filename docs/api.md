---
type: API
title: krateo-private-ca — API
description: The resources the chart renders: the bootstrap Issuer, the CA Certificate, the ClusterIssuer, the CertificateRequestPolicies with their RBAC, and the Bundle.
resource: oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca
tags: [api]
timestamp: 2026-11-11T00:00:00Z
---

# API

| kind | name | purpose |
|---|---|---|
| `Issuer` (namespaced) | `<ca.name>-bootstrap` | self-signs the CA only |
| `Certificate` | `<ca.name>` | the CA (`isCA`, `rotationPolicy: Never`) |
| `ClusterIssuer` | `<ca.name>` | signs service certificates |
| `CertificateRequestPolicy` + `ClusterRole`/`ClusterRoleBinding` | `<ca.name>-bootstrap` | approves the CA's own request |
| `CertificateRequestPolicy` + `ClusterRole`/`ClusterRoleBinding` | `<ca.name>-<issuance.name>` | approves one consumer's names |
| `Bundle` | `<bundle.name>` | the CA certificate as a ConfigMap in each target namespace |
