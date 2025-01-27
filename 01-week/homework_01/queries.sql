select * from yellow_taxi_trips_2019 ytt
left join dim_zones dz on ytt."PULocationID" = dz."LocationID"
left join dim_zones dz2 on ytt."DOLocationID" = dz2."LocationID"




SELECT 
    CASE
        WHEN ytt."trip_distance" <= 1 THEN 3.1
        WHEN ytt."trip_distance" > 1 AND ytt."trip_distance" <= 3 THEN 3.2
        WHEN ytt."trip_distance" > 3 AND ytt."trip_distance" <= 7 THEN 3.3
        WHEN ytt."trip_distance" > 7 AND ytt."trip_distance" <= 10 THEN 3.3
		WHEN ytt."trip_distance" > 10 THEN 3.5
    END AS tipo,
	COUNT(*) AS total
FROM yellow_taxi_trips_2019 ytt
LEFT JOIN dim_zones dz 
    ON ytt."PULocationID" = dz."LocationID"
GROUP BY tipo
ORDER BY tipo;


select 
date(ytt.lpep_pickup_datetime) as pickup_date,
max(ytt.trip_distance) as longest_trip 
from yellow_taxi_trips_2019 ytt
left join dim_zones dz on ytt."PULocationID" = dz."LocationID"
where ytt.lpep_pickup_datetime ilike '%2019-10-11%'
or ytt.lpep_pickup_datetime ilike '2019-10-24%'
or ytt.lpep_pickup_datetime ilike '2019-10-26%'
or ytt.lpep_pickup_datetime ilike '2019-10-31%'
group by
pickup_date
order by
longest_trip  DESC

WITH filtered_trips AS (
    SELECT 
        ytt.index AS trip_index, -- Índice del viaje
        DATE(ytt.lpep_pickup_datetime) AS pickup_date, -- Fecha sin horas ni minutos
        ytt.trip_distance AS trip_distance
    FROM yellow_taxi_trips_2019 ytt
    LEFT JOIN dim_zones dz ON ytt."PULocationID" = dz."LocationID"
    WHERE ytt.lpep_pickup_datetime::TEXT LIKE '%2019-10-11%'
       OR ytt.lpep_pickup_datetime::TEXT LIKE '%2019-10-24%'
       OR ytt.lpep_pickup_datetime::TEXT LIKE '%2019-10-26%'
       OR ytt.lpep_pickup_datetime::TEXT LIKE '%2019-10-31%'
)
SELECT 
    pickup_date, -- Fecha simplificada
    MAX(trip_distance) AS longest_trip, -- Máxima distancia
    trip_index -- Índice del viaje más largo
FROM filtered_trips
WHERE trip_distance = (
    SELECT MAX(trip_distance)
    FROM filtered_trips t2
    WHERE t2.pickup_date = filtered_trips.pickup_date
)
GROUP BY 
    pickup_date, 
    trip_index
ORDER BY 
    pickup_date ASC;

-- Question 5
select * from ( 
select dz."Zone", sum(ytt.total_amount) as total  from yellow_taxi_trips_2019 ytt
left join dim_zones dz on ytt."PULocationID" = dz."LocationID"
where date(ytt.lpep_pickup_datetime) = '2019-10-18'
group by
dz."Zone"
) x
where x.total > 13000

-- Question # 6
select dz."Zone", sum(ytt.tip_amount) as total_tip  from yellow_taxi_trips_2019 ytt
left join dim_zones dz on ytt."PULocationID" = dz."LocationID"
left join dim_zones dz2 on ytt."DOLocationID" = dz2."LocationID" 
group by
dz."Zone"



select x.drop_off, sum(x.total_tip) as top_zones_total_tip
from (
	select dz."Zone" as pick_up
	, dz2."Zone" as drop_off
	, ytt.tip_amount as total_tip  
	from yellow_taxi_trips_2019 ytt
	left join dim_zones dz on ytt."PULocationID" = dz."LocationID"
	left join dim_zones dz2 on ytt."DOLocationID" = dz2."LocationID" 
	where 
	dz."Zone" ilike '%East Harlem North%'
) x
where
x.drop_off like '%Yorkville West%'
or x.drop_off ilike '%JFK Airport%'
or x.drop_off ilike '%East Harlem North%'
or x.drop_off ilike '%East Harlem South%'
group by
x.drop_off
ORDER BY 
top_zones_total_tip DESC