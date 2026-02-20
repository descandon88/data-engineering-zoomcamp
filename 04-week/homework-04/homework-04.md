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