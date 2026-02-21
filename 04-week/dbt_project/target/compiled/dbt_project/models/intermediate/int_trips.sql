

-- Enrich and deduplicate trip data
-- Demonstrates enrichment and surrogate key generation
-- Note: Data quality analysis available in analyses/trips_data_quality.sql

with unioned as (
    select * from "taxi_rides_ny"."prod"."int_trips_unioned"
),

payment_types as (
    select * from "taxi_rides_ny"."prod"."payment_type_lookup"
),

cleaned_and_enriched as (
    select
        -- Generate unique trip identifier (surrogate key pattern)
        md5(cast(coalesce(cast(u.vendor_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(u.pickup_datetime as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(u.pickup_location_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(u.service_type as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as trip_id,

        -- Identifiers
        u.vendor_id,
        u.service_type,
        u.rate_code_id,

        -- Location IDs
        u.pickup_location_id,
        u.dropoff_location_id,

        -- Timestamps
        u.pickup_datetime,
        u.dropoff_datetime,

        -- Trip details
        u.store_and_fwd_flag,
        u.passenger_count,
        u.trip_distance,
        u.trip_type,

        -- Payment breakdown
        u.fare_amount,
        u.extra,
        u.mta_tax,
        u.tip_amount,
        u.tolls_amount,
        u.ehail_fee,
        u.improvement_surcharge,
        u.total_amount,

        -- Enrich with payment type description
        coalesce(u.payment_type, 0) as payment_type,
        coalesce(pt.description, 'Unknown') as payment_type_description

    from unioned u
    left join payment_types pt
        on coalesce(u.payment_type, 0) = pt.payment_type
),

-- select * from cleaned_and_enriched

-- Deduplicate: if multiple trips match (same vendor, second, location, service), keep first
-- qualify row_number() over(
--    partition by vendor_id, pickup_datetime, pickup_location_id, service_type
--     order by dropoff_datetime
-- ) = 1


dedup_keys as (

    select
        vendor_id,
        pickup_datetime,
        pickup_location_id,
        service_type,
        min(dropoff_datetime) as dropoff_datetime
    from cleaned_and_enriched
    group by 1,2,3,4

)

select c.*
from cleaned_and_enriched c
join dedup_keys d
    on c.vendor_id = d.vendor_id
   and c.pickup_datetime = d.pickup_datetime
   and c.pickup_location_id = d.pickup_location_id
   and c.service_type = d.service_type
   and c.dropoff_datetime = d.dropoff_datetime