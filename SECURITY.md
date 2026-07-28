# Security Policy

## Scope

This repository contains an OpenSCAD model, documentation, and CI automation. It
ships no runtime service and collects no user data, so the realistic surface is
the repository's own automation: GitHub Actions workflows, the local smoke
scripts under `scripts/`, and the embedded third-party code documented in
`THIRD_PARTY_NOTICES.md`.

## Reporting a Vulnerability

Use GitHub's private vulnerability reporting:

1. Go to the [Security tab](https://github.com/prisant-labs/3d-cable-box-parametric-openscad/security)
   and choose **Report a vulnerability**.
2. Include reproduction steps, impact, and any suggested mitigation.
3. Do not open a public issue containing exploit details.

Private reporting keeps the discussion invisible until a fix is coordinated, and
it does not require a direct email address from either side.

## Response Goals

- Initial acknowledgment: within 7 days.
- Status update after triage.
- Public disclosure after fix coordination.

## Out of Scope

- Printed-part strength, fit, or dimensional accuracy. Those are model quality
  issues; please open a normal issue instead.
- Vulnerabilities in OpenSCAD itself. Report those upstream to the
  [OpenSCAD project](https://github.com/openscad/openscad).
