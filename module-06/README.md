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

## Question 2 — Average parquet file size after repartition

**Answer: `25MB`**

Downloaded the November 2025 Yellow trip data, read it into a DataFrame,
split it into 4 partitions and wrote it out:

```python
df = spark.read.parquet("yellow_tripdata_2025-11.parquet")
df = df.repartition(4)          # lazy: nothing runs until the write
df.write.mode("overwrite").parquet("yellow_tripdata_2025_11")
```

```text
$ ls -lh yellow_tripdata_2025_11
_SUCCESS
part-00000-...-c000.snappy.parquet   24M
part-00001-...-c000.snappy.parquet   24M
part-00002-...-c000.snappy.parquet   24M
part-00003-...-c000.snappy.parquet   24M
```

Four `.parquet` files, one per partition, each about 24 MiB (about 25.6 MB);
`_SUCCESS` and the hidden `.crc` checksum files are not counted.

Check: without `repartition`, the same write also produced four files of about
21M, because Spark had already split the input into four partitions by
default. Matching the file count alone does not prove the step ran; the
consecutive part numbers and changed sizes do.

## Question 3 — Trips on November 15

**Answer: `162,604`**

Renamed `tpep_pickup_datetime` to `pickup_datetime`, registered the DataFrame
as a temp view and counted trips by pickup date:

```python
df.createOrReplaceTempView("yellow_trips_data_2025_11")

spark.sql("""
SELECT
    COUNT(1) AS count_taxi_trip
FROM
    yellow_trips_data_2025_11
WHERE
    CAST(pickup_datetime AS DATE) = DATE '2025-11-15'
""").show()
```

`pickup_datetime` is a `timestamp_ntz`, so the cast has to sit in the filter.
Comparing the raw timestamp to `DATE '2025-11-15'` matches only trips at exactly
`00:00:00` (10 rows), and `date_trunc` returns a timestamp, not a day number.

## Question 5 — Spark UI port

**Answer: `4040`**

When a session starts, Spark logs `Spark context Web UI available at
http://<host>:4040`. Opening `localhost:4040/jobs/` shows the application's
Jobs page; each action (e.g. `show()`, `write`) appears there as a job.
