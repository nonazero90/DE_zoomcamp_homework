# Module 6 — Batch Processing with Spark

Public artifacts for the 2026 Module 6 homework. Spark runs locally
(PySpark 4.2.1 with Java 17); answers are added as each question is verified.

## Question 1 — Spark version

**Answer: `4.2.1`**

Installed PySpark with pip (it bundles Spark, so no separate `SPARK_HOME` is
needed), started a local session and printed the version:

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.master("local[*]").appName("hw6").getOrCreate()
spark.version   # '4.2.1'
```

The same version is shown in the `pyspark` shell banner.

## Question 5 — Spark UI port

**Answer: `4040`**

When a session starts, Spark logs `Spark context Web UI available at
http://<host>:4040`. Opening `localhost:4040/jobs/` shows the application's
Jobs page; each action (e.g. `show()`, `write`) appears there as a job.
