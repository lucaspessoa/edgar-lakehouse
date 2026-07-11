# ADR-001: Repository structure and tooling

Status: Accepted — 2026-07-11

## Context

The project needs a repository shape and toolchain fixed before any pipeline
code exists. Constraints: single maintainer, public from day one, full
reproducibility from the repo, and execution on Databricks serverless
(Python 3.12.3 across current environment versions).

## Decision

Monorepo layered by concern (infra, src, dbt, orchestration, docs); Python
packages under a src/ layout; Python pinned to 3.12 to match the Databricks
serverless runtime; uv with a committed lockfile for environments; ruff as
sole linter and formatter; pytest with pre-commit hooks mirroring the CI
checks; MIT license.

## Consequences

Cross-cutting changes stay atomic and the history reads as one narrative, at
the cost of a CI that must learn path filtering as the repo grows. The src/
layout adds one directory of indirection but makes tests run against the
installed package. Pinning 3.12 ties local dev to the platform runtime;
moving to 3.13 becomes an explicit, recorded decision.
