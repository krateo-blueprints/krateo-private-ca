---
type: Architecture
title: krateo-private-ca — overview
description: How the CA is bootstrapped, why cert-manager's auto-approval must be off, and how approver-policy limits what the issuer signs.
resource: oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca
tags: [architecture, tls]
timestamp: 2026-11-11T00:00:00Z
---

# Overview

1. A namespaced self-signed `Issuer` signs exactly one certificate: the CA (`isCA`, key never
   rotated, so renewing the CA keeps the public key every trust bundle pins).
2. A `ClusterIssuer` signs service certificates with that CA.
3. With cert-manager's built-in approver **disabled**, nothing is issued unless a
   `CertificateRequestPolicy` approves it. The chart ships one for the CA itself and one per
   `issuance` entry: only those DNS names, only from those namespaces, server-auth leaf only.
4. A trust-manager `Bundle` copies the CA certificate into a ConfigMap in each target namespace and
   keeps it current.

The approval step is the security boundary: without `disableAutoApproval`, the policies decorate
nothing and the issuer signs any name for any namespace.
