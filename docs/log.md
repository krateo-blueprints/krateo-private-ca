---
type: Log
title: krateo-private-ca — log
description: Curated history of krateo-private-ca.
resource: oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca
tags: [log]
timestamp: 2026-11-11T00:00:00Z
---

# Log

## 2026-11-11 — 0.1.0

First release. Designed as an umbrella with approver-policy and trust-manager as subcharts, it could
not install (one release cannot carry a CRD and resources of its kind), so it ships only its own
resources and the dependencies are installed first. Validated on GKE: see [usage](usage.md).
