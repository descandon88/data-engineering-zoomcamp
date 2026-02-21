
    
    

with all_values as (

    select
        service_type as value_field,
        count(*) as n_records

    from "taxi_rides_ny"."prod"."int_trips"
    group by service_type

)

select *
from all_values
where value_field not in (
    'Green','Yellow'
)


