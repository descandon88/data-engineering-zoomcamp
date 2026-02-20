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
