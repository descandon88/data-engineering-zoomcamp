
    
    

select
    payment_type as unique_field,
    count(*) as n_records

from "taxi_rides_ny"."prod"."payment_type_lookup"
where payment_type is not null
group by payment_type
having count(*) > 1


