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

## Question 3 — Overriding a pipeline variable

**Answer: `bruin run --var 'taxi_types=["yellow"]'`**

`taxi_types` is declared as an array of strings, so the override must be a JSON
array, and the flag that overrides pipeline variables is `--var`
(`bruin run --help`).

The outer single quotes matter. Without them the shell rewrites the value
before Bruin sees it: zsh treats `[...]` as a filename pattern and fails with
`no matches found`, and the double quotes are stripped, leaving `[yellow]`,
which is not valid JSON.

- `--taxi-types yellow` — not a Bruin flag; variables go through `--var`.
- `--var taxi_types=yellow` — a plain string, not an array.
- `--set taxi_types=["yellow"]` — wrong flag, and unquoted for the shell.

## Question 4 — Running an asset and everything downstream

**Answer: `bruin run ingestion/trips.py --downstream`**

`bruin run` takes a path (an asset file or a pipeline directory), and
`--downstream` also runs every asset that depends on it, directly or
transitively (`bruin run --help`). In this pipeline that is
`ingestion.trips` → `staging.trips` → `reports.trips_report`.

- `--all` and `--recursive` are not `bruin run` flags.
- `--select` is not a flag either; the dbt-style option is `--selector`, and it
  is spelled differently from the answer option.
