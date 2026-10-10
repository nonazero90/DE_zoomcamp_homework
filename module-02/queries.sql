-- Module 2 Homework (2026)
-- BigQuery validation queries for the final tables populated by Kestra.
-- Replace `your-project` if running these queries in another GCP project.

-- Q3: All rows sourced from the 12 Yellow Taxi CSV files for 2020.
-- Verified result: 24,648,499 rows across 12 source files.
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT filename) AS source_file_count
FROM `your-project.zoomcamp.yellow_tripdata`
WHERE STARTS_WITH(filename, 'yellow_tripdata_2020-');

-- Q4: All rows sourced from the 12 Green Taxi CSV files for 2020.
-- Verified result: 1,734,051 rows across 12 source files.
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT filename) AS source_file_count
FROM `your-project.zoomcamp.green_tripdata`
WHERE STARTS_WITH(filename, 'green_tripdata_2020-');

-- Q5: Rows sourced from the March 2021 Yellow Taxi CSV file.
SELECT COUNT(*) AS row_count
FROM `your-project.zoomcamp.yellow_tripdata`
WHERE filename = 'yellow_tripdata_2021-03.csv';
