# krateo-private-ca

## What is this

A private certificate authority for in-cluster TLS, as Kubernetes resources: a self-signed root CA
behind a cert-manager `ClusterIssuer`; approver-policy `CertificateRequestPolicy` objects so that
issuer signs **only** the DNS names each consumer declares, only from the namespaces it declares; and
a trust-manager `Bundle` publishing the CA certificate (never the key) into the namespaces that must
trust it.

## Install

The chart ships only custom resources, so cert-manager (auto-approval disabled), approver-policy and
trust-manager are installed first, in cert-manager's namespace: see [docs/usage.md](docs/usage.md).

## Configure

See [docs/configuration.md](docs/configuration.md): what the CA may sign (`issuance`) and where its
certificate is published (`bundle`).

## Examples

- [examples/keycloak-openstack](examples/keycloak-openstack/README.md): Keycloak's in-cluster serving
  certificate, trusted by the `openstack` namespace.

## Docs

The bundle starts at [docs/index.md](docs/index.md).

## Develop & release

A plain-semver tag releases the chart to GHCR and the Marketplace index (operators channel):
[docs/release.md](docs/release.md).
