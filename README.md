# edgar-lakehouse

An end-to-end lakehouse on SEC EDGAR filings and market data. It runs on AWS and
Terraform, with Databricks (Delta Lake, Unity Catalog), PySpark, dbt, and Airflow,
and covers batch and streaming ingestion, data-quality checks, ML models,
and dashboards. Built in public, delivery by delivery.

## Project status

**D01, Repository scaffolding & engineering standards** (in progress)

## Why this project

SEC EDGAR is regulatory-grade financial data, and it shows up in three shapes that
really are different: structured market prices, semi-structured XBRL facts, and
unstructured filing text. A tidy CSV would hide the problems worth solving. This
spread does the opposite and puts them in front of you: schema evolution,
late-arriving data, entity resolution across sources. Everything rebuilds from
`terraform apply` and a clone of this repo, infrastructure and pipelines and tests
and dashboards included. Every non-obvious decision goes into an ADR the moment it
gets made.

## Architecture

Diagram lands in D02. Decisions are recorded as [ADRs](docs/adr/).

## Roadmap

Work ships in small, verifiable deliveries. Each one lands through a reviewed PR
with green CI:

| Phase | Scope |
|---|---|
| Foundations | Repo scaffolding, engineering standards, AWS + Terraform bootstrap |
| Ingestion | EDGAR and market-data clients, Postgres source, streaming quote replay |
| Lakehouse | Bronze and Silver layers on Delta Lake (PySpark on Databricks) |
| Modeling | Gold layer with dbt, data-quality suites |
| ML & serving | Feature building, one tracked model with MLflow |
| Orchestration & UX | Airflow DAGs, Streamlit dashboards |

## License

[MIT](LICENSE)
