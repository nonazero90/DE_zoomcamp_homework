with tripdata as (
  select *
  from {{ source('raw_data','fhv_tripdata_non_partitioned') }}
  where dispatching_base_num IS NOT NULL
),

renamed as (
  select
      -- identifiers
      cast(dispatching_base_num as string) as dispatching_base_num,
      cast(PUlocationID as integer) as pickup_locationid,
      cast(DOlocationID as integer) as dropoff_locationid,

      -- timestamps
      cast(pickup_datetime as timestamp) as pickup_datetime,
      cast(dropOff_datetime as timestamp) as dropoff_datetime,

      -- trip info
      cast(SR_Flag as integer) as sr_flag,
      cast(Affiliated_base_number as string) as affiliated_base_number
  from tripdata
)

select * from renamed