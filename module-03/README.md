# Module 3 — Data Warehousing and BigQuery

This directory contains public, reproducible artifacts for the 2026 Module 3
homework. Results and SQL will be added incrementally after each question is
verified.

## Load the source parquet files

The loader streams the January–June 2024 Yellow Taxi parquet files to an
existing Google Cloud Storage bucket. It uses the active Google Cloud CLI
account and requires the bucket name at runtime, so no project ID, bucket name,
or credential file is stored in this repository.

```bash
bash load_yellow_taxi_data.sh YOUR_BUCKET_NAME
```

By default, objects are written below `module-03/`. Pass a second argument to
use another prefix. Re-running the command skips objects that already exist.

Prerequisites:

- `curl`;
- Google Cloud CLI (`gcloud`);
- an existing GCS bucket;
- an active `gcloud` account with permission to read and create objects.

Successful completion lists all six destination objects.
