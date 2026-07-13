# ADR-002: Remote state on S3 with native locking

Status: Accepted — 2026-07-13

## Context

Terraform state must be remote, locked, and survivable; the state bucket
itself must be created by something. Terraform >= 1.11 offers native S3
locking via conditional writes; DynamoDB-based locking is deprecated.
Solo project, personal AWS account, hard US$30 budget.

## Decision

A minimal bootstrap root (local, untracked state) owns the state bucket;
all other roots use the S3 backend with use_lockfile = true. No DynamoDB.
Terraform acts as a dedicated IAM user with AdministratorAccess and
long-lived local keys - a deliberate deviation from Identity Center
best practice, chosen to avoid least-privilege churn at solo scale.

## Consequences

One fewer service to run and explain; lock behavior verified empirically.
Bootstrap state loss is recoverable via a single import. The IAM stance
trades blast-radius protection for velocity; compensating controls are
budget alarms as code, blocked public access everywhere, and ephemeral
infrastructure. Revisit both choices the moment a second operator exists.
