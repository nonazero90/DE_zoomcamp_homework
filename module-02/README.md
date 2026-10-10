# Module 2 — Workflow Orchestration

Artifacts in this directory cover the 2026 Kestra homework:

- backfilling monthly Yellow and Green Taxi workflows;
- validating merged BigQuery tables by source filename;
- configuring a schedule with the `America/New_York` timezone.

The original course flow is maintained upstream in the
[Data Engineering Zoomcamp repository](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/02-workflow-orchestration/flows).
This repository records the homework-specific queries and configuration choices
instead of duplicating the full upstream flow.

## Verified results

| Question | Result | Verification |
| --- | --- | --- |
| Q1 | `134.5 MiB` | Uncompressed Yellow 2020-12 CSV in the Kestra `extract` output |
| Q2 | `green_tripdata_2020-04.csv` | Rendered `file` variable |
| Q3 | `24,648,499` | BigQuery count across 12 Yellow 2020 source files |
| Q4 | `1,734,051` | BigQuery count across 12 Green 2020 source files |
| Q5 | `1,925,152` | Direct row count of the official Yellow 2021-03 source CSV |
| Q6 | `America/New_York` | IANA timezone configured on the Schedule trigger |

The validation queries also count distinct `filename` values for the full-year
questions. This prevents an incomplete backfill from being mistaken for a valid
annual total.

