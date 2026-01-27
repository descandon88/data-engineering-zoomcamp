-- SQL Queries for Module 1 Homework: Docker & SQL (2026)
-- Assuming tables: green_taxi_trips (for trip data), zones (for zone lookup)

-- Question 3: Counting short trips
-- For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound),
-- how many trips had a trip_distance of less than or equal to 1 mile?

SELECT COUNT(*)
FROM green_taxi_trips
WHERE lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance <= 1;

-- Answer: 8007

-- Question 4: Longest trip for each day
-- Which was the pick up day with the longest trip distance?
-- Only consider trips with trip_distance less than 100 miles (to exclude data errors).
-- Use the pick up time for your calculations.

SELECT DATE(lpep_pickup_datetime) AS pickup_date, MAX(trip_distance) AS max_distance
FROM green_taxi_trips
WHERE trip_distance < 100
GROUP BY DATE(lpep_pickup_datetime)
ORDER BY max_distance DESC
LIMIT 1;

-- Answer: 2025-11-14

-- Question 5: Biggest pickup zone
-- Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

SELECT z."Zone", SUM(g.total_amount) AS total_amount
FROM green_taxi_trips g
JOIN zones z ON g."PULocationID" = z."LocationID"
WHERE DATE(g.lpep_pickup_datetime) = '2025-11-18'
GROUP BY z."Zone"
ORDER BY total_amount DESC
LIMIT 1;

-- Answer: East Harlem North

-- Question 6: Largest tip
-- For the passengers picked up in the zone named "East Harlem North" in November 2025,
-- which was the drop off zone that had the largest tip?
-- Note: it's tip, not trip. We need the name of the zone, not the ID.

SELECT dz2."Zone" AS drop_off_zone, SUM(g.tip_amount) AS total_tip
FROM green_taxi_trips g
JOIN zones dz ON g."PULocationID" = dz."LocationID"
JOIN zones dz2 ON g."DOLocationID" = dz2."LocationID"
WHERE dz."Zone" = 'East Harlem North'
GROUP BY dz2."Zone"
ORDER BY total_tip DESC
LIMIT 1;

-- Answer: East Harlem North 
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