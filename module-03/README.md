# Module 3 — Data Warehousing and BigQuery

This directory contains public, reproducible artifacts for the 2026 Module 3
homework. Results and SQL will be added incrementally after each question is
verified.

## Load the source parquet files

The loader downloads the January–June 2024 Yellow Taxi parquet files into a
temporary directory and uploads them to an existing Google Cloud Storage
bucket. It uses Application Default Credentials and requires the bucket name at
runtime, so no project ID, bucket name, or credential file is stored here.

```bash
uv sync
.venv/bin/python load_yellow_taxi_data.py --bucket YOUR_BUCKET_NAME
```

By default, objects are written below `module-03/`. Pass `--prefix NAME` to use
another prefix. Re-running the command skips objects that already exist. Local
downloads are removed automatically when the process exits normally.

Prerequisites:

- Python 3.13 or newer;
- `uv`;
- an existing GCS bucket;
- Application Default Credentials with permission to read and create objects.

Successful completion prints one `Uploaded gs://...` or `Exists, skipping`
line for each of the six monthly files.
