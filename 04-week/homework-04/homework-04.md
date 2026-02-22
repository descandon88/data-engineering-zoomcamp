# Question 1: dbt Lineage and Execution

## Correct Answer

**stg_green_tripdata, stg_yellow_tripdata, and int_trips_unioned (upstream dependencies)**

---

## Explanation

Given the project structure:

```
models/
├── staging/
│   ├── stg_green_tripdata.sql
│   └── stg_yellow_tripdata.sql
└── intermediate/
    └── int_trips_unioned.sql
```

And assuming `int_trips_unioned.sql` depends on:

```sql
{{ ref('stg_green_tripdata') }}
{{ ref('stg_yellow_tripdata') }}

when running:
dbt run --select int_trips_unioned
```

# Question 2: dbt test

## Correct Answer

**dbt will fail the test, returning a non-zero exit code**
```
  LINE 18: from "taxi_rides_ny"."dev"."fct_trips"
                ^
17:21:06
17:21:06    compiled code at target/compiled/dbt_project/models/marts/schema.yml/unique_fct_trips_trip_id.sql
17:21:06  
17:21:06  Done. PASS=0 WARN=0 ERROR=9 SKIP=0 NO-OP=0 TOTAL=9
root@b44600328ca7:/usr/app# 
```

# Question 3: Count of records in fct_monthly_zone_revenue

## Correct Answer

**12,184**

```
root@f6f0f579cc02:/usr/app# duckdb taxi_rides_ny.duckdb
DuckDB v1.4.4 (Andium) 6ddac802ff
Enter ".help" for usage hints.
D select count(*) from prod.fct_monthly_zone_revenue;
100% ▕██████████████████████████████████████▏ (00:00:13.77 elapsed)     
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│    12184     │
└──────────────┘
```

# Question 4: 

## Correct Answer
**East Harlem North**


D select ft.pickup_zone, sum(ft.total_amount) as total_revenue from prod.fct_trips ft where ft.service_type = 'Green' and YEAR(ft.pickup_datetime) = 2020 group by ft.pickup_zone order by sum(ft.total_amount) DESC LIMIT 1;
┌───────────────────┬───────────────┐
│    pickup_zone    │ total_revenue │
│      varchar      │ decimal(38,3) │
├───────────────────┼───────────────┤
│ East Harlem North │  1817426.300  │
└───────────────────┴───────────────┘
D

# Question 5: 

## Correct Answer
**5610885**
```
select count(ft.trip_id)  from prod.fct_trips ft where year(ft.pickup_datetime) in (2019) and month(ft.pickup_datetime) and ft.service_type like '%Green%' ;
┌───────────────────┐
│ count(ft.trip_id) │
│       int64       │
├───────────────────┤
│      5610885      │
│  (5.61 million)   │
└───────────────────┘
```


# Question 6: count of records in stg_fhv_tripdata

## Correct Answer
**43244693**

```
05:11:54  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=1
root@f6f0f579cc02:/usr/app# duckdb taxi_rides_ny.duckdb
DuckDB v1.4.4 (Andium) 6ddac802ff
Enter ".help" for usage hints.
D select count(*) from prod.stg_fhv_tripdata;
┌─────────────────┐
│  count_star()   │
│      int64      │
├─────────────────┤
│    43244693     │
│ (43.24 million) │
└─────────────────
```