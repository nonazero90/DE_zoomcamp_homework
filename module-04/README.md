# Module 4 — Analytics Engineering with dbt

This directory contains public, reproducible artifacts for the 2026 Module 4
homework. Models, queries, and verified answers will be added incrementally.

## Environment milestone

The local dbt profile has separate development and production outputs. The
production output uses its own BigQuery dataset; project identifiers and
credentials remain in the local profile and are not stored in this repository.

From the dbt project directory, the production connection was verified with:

```bash
dbt debug --target prod
```

Verified on 2026-10-20: the profile, dbt project, dependencies, and BigQuery
connection checks all passed. No models were built during this step.

## Question 3 — Count of records in `fct_monthly_zone_revenue`

**Answer: 12,184**

```sql
select count(*)
from `<project>.<prod_dataset>.fct_monthly_zone_revenue`;
```

The mart has one row per pickup zone × revenue month × service type, so this
counts zone/month/service combinations, not trips.

### Debugging note

The first rebuild returned 14,004, which matched none of the options. Checks used:

1. Row count per `service_type` and `revenue_month` in the mart: none of the 24
   months was missing for either service, but there were whole extra months in 2021.
2. Row count per `filename` in the raw Green and Yellow tables: the loading
   flow had also backfilled `green_tripdata_2021-01` … `2021-07` and
   `yellow_tripdata_2021-01`, which this homework does not use.
3. Filtering the mart with `year != 2021` gave 12,164. That is too low because
   it also drops 2019–2020 trips whose pickup timestamp falls in 2021 (trips
   crossing midnight, bad timestamps). Those rows exist in everyone's data.

Fix: exclude the extra files at the source, in both staging models:

```sql
where vendorid is not null
  and filename not like 'green_tripdata_2021%'   -- yellow: 'yellow_tripdata_2021%'
```

After this change, running `dbt build --target prod --full-refresh --select
+fct_monthly_zone_revenue` gives 12,184 rows. Year values far outside 2019–2020
(for example 2001 or 2088) come from bad timestamps in the source files and are
kept.

## Question 4 — Best-performing Green pickup zone in 2020

**Answer: East Harlem North** (total revenue 1,817,268.95)

```sql
select pickup_zone, sum(revenue_monthly_total_amount) as total_revenue
from `<project>.<prod_dataset>.fct_monthly_zone_revenue`
where service_type = 'Green'
  and extract(year from revenue_month) = 2020
group by pickup_zone
order by total_revenue desc;
```

The question asks for a yearly total, so one result row must be one pickup
zone. Grouping by `pickup_zone, revenue_month` instead would rank single
zone-months, not each zone's 2020 total.

## Question 5 — Green taxi trip count for October 2019

**Answer: 384,624**

```sql
select sum(total_monthly_trips) as total_number_of_trips
from `<project>.<prod_dataset>.fct_monthly_zone_revenue`
where service_type = 'Green'
  and extract(year from revenue_month) = 2019
  and extract(month from revenue_month) = 10;
```

The mart has one row per zone per month, so `count(*)` would count zones.
`sum(total_monthly_trips)` adds the trip counts of every zone into one row:
all Green trips in October 2019.
