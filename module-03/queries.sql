-- Module 3 Homework: Data Warehousing and BigQuery
-- Replace the public-safe placeholders before running the setup statements.

-- BigQuery setup: the row data remains in GCS.
CREATE EXTERNAL TABLE `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_external`
OPTIONS (
  format = 'PARQUET',
  uris = [
    'gs://YOUR_BUCKET_NAME/module-03/yellow_tripdata_2024-*.parquet'
  ]
);

-- BigQuery setup: the query result is stored as a managed table.
CREATE TABLE `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_non_partitioned` AS
SELECT *
FROM `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_external`;

-- Question 1: count all records.
SELECT COUNT(*) AS record_count
FROM `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_non_partitioned`;

-- Question 2: compare the pre-execution estimates for these two queries.
SELECT COUNT(DISTINCT PULocationID) AS distinct_pickup_locations
FROM `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_external`;

SELECT COUNT(DISTINCT PULocationID) AS distinct_pickup_locations
FROM `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_non_partitioned`;

-- Question 3: compare the estimated bytes for one column versus two columns.
SELECT PULocationID
FROM `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_non_partitioned`;

SELECT PULocationID, DOLocationID
FROM `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_non_partitioned`;

-- Question 4: count trips with a zero fare.
-- The predicate excludes NULL, so COUNT(fare_amount) equals COUNT(*) here.
SELECT COUNT(fare_amount) AS zero_fare_trip_count
FROM `YOUR_PROJECT_ID.zoomcamp.yellow_tripdata_2024_non_partitioned`
WHERE fare_amount = 0;
