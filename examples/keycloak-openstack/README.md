---
type: Example
title: krateo-private-ca — Keycloak and OpenStack example
description: Keycloak's in-cluster serving certificate signed by the private CA, and its CA published to the openstack namespace.
resource: oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca
tags: [example]
timestamp: 2026-11-11T00:00:00Z
---

# Keycloak and OpenStack

[values.yaml](values.yaml) lets the CA sign only `keycloak-service.keycloak-system.svc[.cluster.local]`
for namespace `keycloak-system`, and publishes the CA as ConfigMap `keycloak-ca` (key `ca.crt`) in
`openstack`, where Keystone and Horizon mount it as their CA bundle.
