# Marketing Data Platform 🚧

End-to-end data platform for marketing analytics: ingesting ad platform and web analytics data, modeling it in a warehouse, and serving it to dashboards.

## Goals
- Ingest paid media data (Meta Ads / Google Ads format) and GA4 e-commerce data
- Model campaigns × conversions with a dimensional (star schema) approach
- Orchestrate, test and deploy the pipeline like production code

## Planned stack
| Layer | Tool |
|---|---|
| Ingestion | Python |
| Storage / Warehouse | Google Cloud Storage, BigQuery |
| Transformation | dbt |
| Orchestration | Apache Airflow |
| Infrastructure | Docker, Terraform |
| CI/CD | GitHub Actions |
| Visualization | Looker Studio |

## Roadmap
- [ ] Local environment with Docker
- [ ] Ingestion scripts + sample data
- [ ] Star schema design
- [ ] dbt models and tests
- [ ] Airflow DAG
- [ ] Terraform + CI/CD
- [ ] Dashboard

## Data
Public and synthetic data only — no client data.
