
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select payment_type
from "taxi_rides_ny"."prod"."payment_type_lookup"
where payment_type is null



  
  
      
    ) dbt_internal_test