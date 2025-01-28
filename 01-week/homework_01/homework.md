# Module 1 Homework: Docker & SQL

In this homework we'll prepare the environment and practice
Docker and SQL

When submitting your homework, you will also need to include
a link to your GitHub repository or other public code-hosting
site.

This repository should contain the code for solving the homework. 

When your solution has SQL or shell commands and not code
(e.g. python files) file format, include them directly in
the README file of your repository.


## Question 1. Understanding docker first run 

Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint `bash`.

What's the version of `pip` in the image?

- 24.3.1 
- 24.2.1
- 23.3.1
- 23.2.1


**Answer:**
pip 24.3.1 

**Solution:**
``` 
  docker run -it --name hm01-first-question --entrypoint bash python:3.12.8 
  Unable to find image 'python:3.12.8' locally
  3.12.8: Pulling from library/python
  e474a4a4cbbf: Pull complete 
  d22b85d68f8a: Pull complete 
  936252136b92: Pull complete 
  94c5996c7a64: Pull complete 
  c980de82d033: Pull complete 
  c80762877ac5: Pull complete 
  86f9cc2995ad: Pull complete 
  Digest: sha256:2e726959b8df5cd9fd95a4cbd6dcd23d8a89e750e9c2c5dc077ba56365c6a925
  Status: Downloaded newer image for python:3.12.8
  root@7339a103fe8e:/# pip -version

  Usage:   
    pip <command> [options]

  no such option: -e
  root@7339a103fe8e:/# pip --version
  pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```

## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that **pgadmin** should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

If there are more than one answers, select only one of them

 **Answer:**
 db:5432
 
 **Solution:**
 <img src="img/Screenshot 2025-01-27 at 16.29.49.png" alt="img capture" max-height='300'/>



##  Prepare Postgres

Run Postgres and load data as shown in the videos
We'll use the green taxi trips from October 2019:

```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
```

You will also need the dataset with zones:

```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```

Download this data and put it into Postgres.

You can use the code from the course. It's up to you whether
you want to use Jupyter or a python script.

## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:
1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles 

Answers:

- 104,802;  197,670;  110,612;  27,831;  35,281
- 104,802;  198,924;  109,603;  27,678;  35,189
- 104,793;  201,407;  110,612;  27,831;  35,281
- 104,793;  202,661;  109,603;  27,678;  35,189
- 104,838;  199,013;  109,645;  27,688;  35,202

**Answer:**
- 104,838;  199,013;  109,645;  27,688;  35,202

**Solution:**
```sql
SELECT 
    CASE
        WHEN ytt."trip_distance" <= 1 THEN 3.1
        WHEN ytt."trip_distance" > 1 AND ytt."trip_distance" <= 3 THEN 3.2
        WHEN ytt."trip_distance" > 3 AND ytt."trip_distance" <= 7 THEN 3.3
        WHEN ytt."trip_distance" > 7 AND ytt."trip_distance" <= 10 THEN 3.4
		WHEN ytt."trip_distance" > 10 THEN 3.5
    END AS tipo,
	COUNT(*) AS total
FROM yellow_taxi_trips_2019 ytt
LEFT JOIN dim_zones dz 
    ON ytt."PULocationID" = dz."LocationID"
GROUP BY tipo
ORDER BY tipo;
```
 <img src="img/capture_2.png" alt="img capture 2" max-height='330'/>

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance?
Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance. 

- 2019-10-11
- 2019-10-24
- 2019-10-26
- 2019-10-31

**Answer:**
- 2019-10-31

**Solution:**
```sql

select date(ytt.lpep_pickup_datetime) as pickup_date,
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
 ```
 <img src="img/capture_3.png" alt="img capture 2" max-height='330'/>

## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in
`total_amount` (across all trips) for 2019-10-18?

Consider only `lpep_pickup_datetime` when filtering by date.
 
- East Harlem North, East Harlem South, Morningside Heights
- East Harlem North, Morningside Heights
- Morningside Heights, Astoria Park, East Harlem South
- Bedford, East Harlem North, Astoria Park

**Answer:**
- East Harlem North, East Harlem South, Morningside Heights

**Solution:**
```sql
select * from ( 
select dz."Zone", sum(ytt.total_amount) as total  from yellow_taxi_trips_2019 ytt
left join dim_zones dz on ytt."PULocationID" = dz."LocationID"
where date(ytt.lpep_pickup_datetime) = '2019-10-18'
group by
dz."Zone"
) x
where x.total > 13000
```
 <img src="img/capture_4.png" alt="img capture 4" max-height='330'/>

## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone
named "East Harlem North" which was the drop off zone that had
the largest tip?

Note: it's `tip` , not `trip`

We need the name of the zone, not the ID.

- Yorkville West
- JFK Airport
- East Harlem North
- East Harlem South

**Answer:**
- East Harlem South

**Solution:**

```sql

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
```
 <img src="img/capture_5.png" alt="img capture 4" max-height='330'/>



## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. 
Copy the files from the course repo
[here](../../../01-docker-terraform/1_terraform_gcp/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.


## Question 7. Terraform Workflow

Which of the following sequences, **respectively**, describes the workflow for: 
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:
- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- terraform init, terraform apply -auto-approve, terraform destroy
- terraform import, terraform apply -y, terraform rm

**Answer:**
- terraform init, terraform apply -auto-approve, terraform destroy


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw1
