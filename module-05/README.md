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
