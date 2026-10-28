# Module 5 — Data Platforms with Bruin

Public artifacts for the 2026 Module 5 homework. The pipeline runs locally on
DuckDB; answers are added as each question is verified.

## Question 1 — Required files in a Bruin project

**Answer: `.bruin.yml` and `pipeline/` with `pipeline.yml` and `assets/`**

- `.bruin.yml` — environments and connections (e.g. the DuckDB file). It holds
  credentials, so it lives at the repository root and is git-ignored.
- `pipeline/pipeline.yml` — the pipeline definition: name, schedule, default
  connections, variables.
- `pipeline/assets/` — the SQL, Python and YAML assets; each one builds a table.

Verified against the working pipeline layout:

```text
.bruin.yml            # repository root, not committed
my-pipeline/
└── pipeline/
    ├── pipeline.yml
    └── assets/
        ├── ingestion/
        ├── staging/
        └── reports/
```

## Question 2 — Materialization strategy

**Answer: `time_interval`**

Each run should replace only the rows whose `pickup_datetime` falls in the
requested interval and leave every other month untouched.

- `append` never deletes, so re-running a month duplicates its rows.
- `replace` truncates the whole table, losing months outside the interval.
- `view` stores no data at all.

Verified against `pipeline/assets/staging/trips.sql`:

```yaml
materialization:
  type: table
  strategy: time_interval        # delete the interval, then insert it again
  incremental_key: pickup_datetime   # column that defines the interval
  time_granularity: timestamp
```

On the first run the table did not exist yet, so the DELETE step failed;
`bruin run --full-refresh` created it, and later runs are incremental.
