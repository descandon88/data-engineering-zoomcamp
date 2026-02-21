-- Dimension table for taxi technology vendors
-- Small static dimension defining vendor codes and their company names

with trips as (
    select * from "taxi_rides_ny"."dev"."fct_trips"
),

vendors as (
    select distinct
        vendor_id,
        



case vendor_id
    
    when 1 then 'Creative Mobile Technologies'
    
    when 2 then 'VeriFone Inc.'
    
    when 4 then 'Unknown/Other'
    
end

 as vendor_name
    from trips
)

select * from vendors