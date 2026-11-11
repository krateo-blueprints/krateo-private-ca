---
type: Runbook
title: krateo-private-ca — release
description: How a release ships: a plain-semver tag on a main commit that passed lint publishes the chart to GHCR and the Marketplace index (operators channel).
resource: oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca
tags: [release]
timestamp: 2026-11-11T00:00:00Z
---

# Release

Tag a commit on `main` whose `lint` run passed with a plain semver (`X.Y.Z`). The release-tag workflow
pushes `oci://ghcr.io/krateo-blueprints/charts/krateo-private-ca:X.Y.Z` and publishes the same archive
to the Marketplace index, channel `operators` (no CompositionDefinition). Verify that the OCI
archive's sha256 equals the index entry's digest.
