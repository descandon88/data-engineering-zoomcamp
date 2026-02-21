
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

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



  
  
      
    ) dbt_internal_test