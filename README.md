# krateo-private-ca

A private certificate authority for in-cluster TLS, as Kubernetes resources:

- a self-signed root CA (key never rotated, so published trust never breaks) behind a cert-manager
  `ClusterIssuer`;
- approver-policy `CertificateRequestPolicy` objects so that issuer signs **only** the DNS names each
  consumer declares, only from the namespaces it declares, only as a server leaf;
- a trust-manager `Bundle` publishing the CA certificate (never the key) as a ConfigMap into the
  namespaces that must trust it.

## Install order

The chart ships only custom resources, so their CRDs must exist first; one Helm release cannot carry
both a CRD and resources of its kind. Install, in this order, into cert-manager's namespace:

```console
$ helm install cert-manager jetstack/cert-manager --version v1.21.3 -n cert-manager --create-namespace \
    --set crds.enabled=true --set disableAutoApproval=true
$ helm install approver-policy jetstack/cert-manager-approver-policy --version v0.29.0 -n cert-manager
$ helm install trust-manager jetstack/trust-manager --version v0.26.0 -n cert-manager \
    --set app.trust.namespace=cert-manager \
    --set app.webhook.tls.approverPolicy.enabled=true
$ helm install private-ca oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca -n cert-manager -f values.yaml
```

`disableAutoApproval: true` is what makes the policies mean anything: without it cert-manager
approves every request itself. trust-manager's own webhook certificate then needs a policy too, which
its `app.webhook.tls.approverPolicy.enabled` provides.

## Values

```yaml
issuance:                      # what the CA may sign; empty = nothing
  - name: keycloak
    namespaces: [keycloak-system]
    dnsNames:
      - keycloak-service.keycloak-system.svc
      - keycloak-service.keycloak-system.svc.cluster.local
bundle:
  name: keycloak-ca            # ConfigMap name in each target namespace (key: ca.crt)
  namespaces: [openstack]
maxDuration: ""                # optional; when set, consumers' Certificates MUST set spec.duration
```

## Measured (GKE, cert-manager v1.21.3, approver-policy v0.29.0, trust-manager v0.26.0)

| request | result |
|---|---|
| allowed name, allowed namespace | Approved by the issuance policy, issued |
| `evil.example.com`, allowed namespace | Denied (`spec.allowed.dnsNames.values`) |
| allowed name, other namespace | never approved (no policy selects it), never signed |
| leaf vs published bundle | `openssl verify` OK; leaf carries an Authority Key Identifier |
| `maxDuration` set, Certificate without `spec.duration` | Denied (`spec.constraints.maxDuration: Invalid value: "nil"`) |
