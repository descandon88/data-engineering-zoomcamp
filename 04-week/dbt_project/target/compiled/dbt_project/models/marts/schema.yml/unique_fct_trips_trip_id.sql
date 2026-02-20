
    
    

select
    trip_id as unique_field,
    count(*) as n_records

from "taxi_rides_ny"."dev"."fct_trips"
where trip_id is not null
group by trip_id
having count(*) > 1


