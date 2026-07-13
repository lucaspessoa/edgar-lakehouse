# Architecture

Target architecture as of D02. Solid nodes exist; dashed nodes are planned.
The diagram is Mermaid source, versioned with the code — each delivery that
changes the system changes this file in the same PR.

```mermaid
flowchart LR
  subgraph sources[Sources]
    stooq[Market prices]
    edgar[SEC EDGAR API]
    sim[Quote stream - simulated]
  end

  subgraph aws[AWS us-east-1]
    rds[(RDS PostgreSQL)]
    subgraph s3[S3 lakehouse layers]
      landing[Landing]
      bronze[Bronze]
      silver[Silver]
      gold[Gold]
    end
    budgets[Budget alarms 10/20 USD]
  end

  subgraph dbx[Databricks Free Edition]
    spark[PySpark ingestion]
    dbt[dbt marts]
    ml[MLflow model]
  end

  dash[Dashboards: AI/BI + Streamlit]

  stooq --> rds --> landing
  edgar --> landing
  sim -.-> landing
  landing --> bronze --> silver --> gold
  spark --- bronze
  spark --- silver
  dbt --- gold
  gold --> ml
  gold --> dash

  classDef built stroke-width:2px
  classDef planned stroke-dasharray:5 5
  class landing,bronze,silver,gold,budgets built
  class stooq,edgar,sim,rds,spark,dbt,ml,dash planned
```

Infrastructure state: Terraform, remote state on S3 with native lockfile
locking ([ADR-002](adr/0002-remote-state-locking-and-iam-stance.md)). The
lakehouse buckets, the budget alarms and the state backend were provisioned
in D02; everything downstream of landing arrives in later deliveries.
