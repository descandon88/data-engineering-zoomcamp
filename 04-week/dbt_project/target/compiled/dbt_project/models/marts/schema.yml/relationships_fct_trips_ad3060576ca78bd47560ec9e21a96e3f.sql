
    
    

with child as (
    select dropoff_location_id as from_field
    from "taxi_rides_ny"."dev"."fct_trips"
    where dropoff_location_id is not null
),

parent as (
    select location_id as to_field
    from "taxi_rides_ny"."dev"."dim_zones"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


