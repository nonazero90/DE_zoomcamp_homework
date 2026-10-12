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

Verified on 2026-10-12: all six monthly objects were present in GCS, totaling
341,935,880 bytes (326.10 MiB). The bucket name is intentionally omitted.

## BigQuery setup

The source files were registered as a Parquet external table. A separate
non-partitioned, non-clustered managed table was then created from it. The
reproducible SQL is in [`queries.sql`](queries.sql), with public-safe
placeholders for the project and bucket names.

Verification confirmed that the external table referenced the six GCS files
without storing managed bytes in BigQuery. The regular table was stored in
BigQuery and contained 20,332,093 rows.

## Verified answers

### Question 1 — Counting records

The January–June 2024 dataset contains **20,332,093 rows**.

### Question 2 — Data read estimation

The BigQuery estimates shown before execution were:

- external table: **0 B**;
- managed table: **155.12 MB**.

The external-table value is a lower-bound planning estimate, not evidence that
an executed query reads no data from GCS.

### Question 3 — Columnar storage

BigQuery scans only the columns requested by a query. Selecting both
`PULocationID` and `DOLocationID` therefore reads more data than selecting only
`PULocationID`. Specific UI estimates were not recorded for this question.

### Question 4 — Zero-fare trips

There are **8,333 rows** where `fare_amount = 0`.
