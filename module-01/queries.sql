-- Module 1 Homework (2026)
-- PostgreSQL queries for NYC Green Taxi data, November 2025.

-- Q3: Trips with a distance less than or equal to one mile.
-- Verified result: 8,007
SELECT COUNT(*) AS short_trip_count
FROM public.green_trips
WHERE lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance <= 1;

-- Q4: Pickup day containing the longest trip below 100 miles.
-- Verified result: 2025-11-14 (88.03 miles)
SELECT trip_distance, lpep_pickup_datetime
FROM public.green_trips
WHERE trip_distance < 100
ORDER BY trip_distance DESC
LIMIT 1;

-- Q5: Pickup zone with the largest total amount on 2025-11-18.
-- Verified result: East Harlem North
SELECT
    z."Zone",
    SUM(g.total_amount) AS total_amount_sum
FROM public.green_trips AS g
JOIN public.zones AS z
    ON g."PULocationID" = z."LocationID"
WHERE g.lpep_pickup_datetime >= '2025-11-18'
  AND g.lpep_pickup_datetime < '2025-11-19'
GROUP BY z."Zone"
ORDER BY total_amount_sum DESC
LIMIT 1;

-- Q6: Dropoff zone for the largest individual tip from trips picked up
-- in East Harlem North during November 2025.
-- Verified result: Yorkville West (tip amount 81.89)
SELECT
    g.tip_amount,
    pickup_zone."Zone" AS pickup_zone,
    dropoff_zone."Zone" AS dropoff_zone
FROM public.green_trips AS g
JOIN public.zones AS pickup_zone
    ON g."PULocationID" = pickup_zone."LocationID"
JOIN public.zones AS dropoff_zone
    ON g."DOLocationID" = dropoff_zone."LocationID"
WHERE pickup_zone."Zone" = 'East Harlem North'
  AND g.lpep_pickup_datetime >= '2025-11-01'
  AND g.lpep_pickup_datetime < '2025-12-01'
ORDER BY g.tip_amount DESC
LIMIT 1;
