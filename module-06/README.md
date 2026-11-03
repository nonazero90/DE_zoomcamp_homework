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
df_yellow.createOrReplaceTempView("yellow_trips_data_2025_11")

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

## Question 4 — Longest trip in hours

**Answer: `90.6`**

Also renamed `tpep_dropoff_datetime` to `dropoff_datetime`. Computed each trip's
duration in minutes, took the maximum and converted it to hours:

```python
spark.sql("""
SELECT
    MAX(timestampdiff(MINUTE, pickup_datetime, dropoff_datetime)) / 60 AS hours
FROM
    yellow_trips_data_2025_11
""").show()
```

```text
+-----------------+
|            hours|
+-----------------+
|90.63333333333334|
+-----------------+
```

Subtracting the two timestamps directly returns an `INTERVAL`, not a number, so
`timestampdiff` is used instead. Using `HOUR` as the unit would truncate to a
whole number, so the difference is taken in minutes and divided by 60.
`timestampdiff` is parser syntax: it does not appear in `SHOW FUNCTIONS` or the
SQL built-in functions page, but it works in `spark.sql`.

## Question 6 — Least frequent pickup zone

**Answer: `Governor's Island/Ellis Island/Liberty Island`** (tied; see below)

Loaded the zone lookup CSV (with `header=true`) as a second temp view and joined
it to the trips on the pickup location ID:

```python
df_zone.createOrReplaceTempView("taxi_zone_lookup")

spark.sql("""
SELECT
    y.PULocationID,
    z.Zone,
    COUNT(*) AS pickup_times
FROM
    yellow_trips_data_2025_11 AS y
JOIN taxi_zone_lookup AS z
    ON y.PULocationID = z.LocationID
GROUP BY y.PULocationID, z.Zone
ORDER BY pickup_times
""").show()
```

```text
+------------+--------------------+------------+
|PULocationID|                Zone|pickup_times|
+------------+--------------------+------------+
|          84|Eltingville/Annad...|           1|
|           5|       Arden Heights|           1|
|         105|Governor's Island...|           1|
|         187|       Port Richmond|           3|
...
```

One output row is one pickup zone. Three zones tie at a single pickup, and two
of them (Governor's Island and Arden Heights) are answer options; the homework
accepts any correct one. `ORDER BY` alone does not break ties, so the row order
among them is not guaranteed. The inner join only counts zones that have at
least one pickup, so zones with zero pickups never appear.

## Question 5 — Spark UI port

**Answer: `4040`**

When a session starts, Spark logs `Spark context Web UI available at
http://<host>:4040`. Opening `localhost:4040/jobs/` shows the application's
Jobs page; each action (e.g. `show()`, `write`) appears there as a job.
