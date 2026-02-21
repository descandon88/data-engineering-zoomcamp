with source as (
    select * from {{ source('raw', 'fhv_tripdata') }}
),

renamed as (

    select
        cast(dispatching_base_num as varchar) as vendor_id,
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropOff_datetime as timestamp) as dropoff_datetime,
        cast(PUlocationID as integer) as pickup_location_id,
        cast(DOlocationID as integer) as dropoff_location_id,
        cast(SR_Flag as varchar) as sr_flag,
        cast(Affiliated_base_number as varchar) as affiliated_base_number,
        'fhv' as service_type

    from source
    where dispatching_base_num is not null

)

select * from renamed


{% if target.name == 'dev' %}
where pickup_datetime >= '2019-01-01' and pickup_datetime < '2019-02-01'
{% endif %}


