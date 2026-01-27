# Module 1 Homework: Docker & SQL

This repository contains the solutions for Module 1 of the Data Engineering Zoomcamp (2026 edition). In this homework, we'll prepare the environment and practice Docker and SQL.

## Overview

The homework covers:

- Docker basics and containerization
- Docker Compose for multi-container applications
- PostgreSQL database setup and data ingestion
- SQL queries for data analysis on NYC Green Taxi data
- Terraform for GCP infrastructure provisioning

## Prerequisites

- Docker and Docker Compose installed
- Python 3.12
- PostgreSQL (via Docker)
- Terraform (for the GCP section)
- Access to GCP account (for Terraform section)

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/descandon88/data-engineering-zoomcamp.git
cd homework_01
```

### 2. Download Data

Download the green taxi trips data for November 2025:

```bash
wget https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet
```

Download the taxi zone lookup data:

```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```

Place the downloaded files in the `data/` directory.

### 3. Set Up PostgreSQL with Docker

Use the provided `docker-compose.yaml` to start PostgreSQL and pgAdmin:

```bash
docker-compose up -d
```

This will start:

- PostgreSQL on port 5433 (host) / 5432 (container)
- pgAdmin on port 8080

Connect to pgAdmin at http://localhost:8080 with:

- Email: pgadmin@pgadmin.com
- Password: pgadmin

### 4. Ingest Data

Run the Python scripts to ingest data into PostgreSQL:

```bash
python ingest_data_taxi_trips_2025.py  # Assuming you have a script for parquet
python ingest_data_zones.py
```

Or use the Jupyter notebooks in the `notebooks/` folder for interactive ingestion.

**Note:** The homework expects you to load the data into PostgreSQL and use SQL queries for analysis. Your Python solutions in the notebook are correct but to follow the instructions, use SQL on the database.

### Automated Pipeline Setup

For convenience, a batch script `run_pipeline_homework_01.bat` has been created to automate the entire setup process:

```cmd
run_pipeline_homework_01.bat
```

This script will:

- Download the required data files
- Start Docker containers (PostgreSQL and pgAdmin)
- Install Python dependencies
- Ingest data into PostgreSQL
- Provide connection information

## Solutions

The homework solutions are provided in two formats:

1. **SQL Queries** (`queries.sql`): Direct SQL queries to run against the PostgreSQL database
2. **Python Analysis** (`notebooks/notebook_homework_01.ipynb`): Pandas-based analysis in Jupyter notebook

Both approaches yield the same results, but the SQL version follows the homework requirements more closely.

## Questions and Solutions

### Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.

What's the version of `pip` in the image?

- 25.3
- 24.3.1
- 24.2.1
- 23.3.1

**Solution:**

```bash
docker run -it --rm --entrypoint bash python:3.13
pip --version
```

**Answer:** 25.3

### Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
      POSTGRES_DB: "ny_taxi"
    ports:
      - "5433:5432"
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

**Answer:** db:5432

### Question 3. Counting short trips

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a `trip_distance` of less than or equal to 1 mile?

- 7,853
- 8,007
- 8,254
- 8,421

**Solution (SQL - Recommended):**

```sql
SELECT COUNT(*)
FROM green_taxi_trips
WHERE lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance <= 1;
```

**Solution (Python - as implemented in notebook):**

```python
dq3 = df.copy()
dq3 = dq3[(dq3['lpep_pickup_datetime']>'2025-11-01') &
    (dq3['lpep_pickup_datetime']<='2025-12-01') &
    (dq3['trip_distance']<=1)
]
count = dq3.VendorID.count()
```

**Answer:** 8,007

### Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Only consider trips with `trip_distance` less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

- 2025-11-14
- 2025-11-20
- 2025-11-23
- 2025-11-25

**Solution (SQL - Recommended):**

```sql
SELECT DATE(lpep_pickup_datetime) AS pickup_date, MAX(trip_distance) AS max_distance
FROM green_taxi_trips
WHERE trip_distance < 100
GROUP BY DATE(lpep_pickup_datetime)
ORDER BY max_distance DESC
LIMIT 1;
```

**Solution (Python - as implemented in notebook):**

```python
dq4 = df.copy()
dq4 = dq4[dq4['trip_distance']<100]
max_trip_distance = dq4['trip_distance'].idxmax()
pickup_datetime = dq4.loc[max_trip_distance]
print(pickup_datetime.lpep_pickup_datetime)
```

**Answer:** 2025-11-14

### Question 5. Biggest pickup zone

Which was the pickup zone with the largest `total_amount` (sum of all trips) on November 18th, 2025?

- East Harlem North
- East Harlem South
- Morningside Heights
- Forest Hills

**Solution (SQL - Recommended):**

```sql
SELECT z."Zone", SUM(g.total_amount) AS total_amount
FROM green_taxi_trips g
JOIN zones z ON g."PULocationID" = z."LocationID"
WHERE DATE(g.lpep_pickup_datetime) = '2025-11-18'
GROUP BY z."Zone"
ORDER BY total_amount DESC
LIMIT 1;
```

**Solution (Python - as implemented in notebook):**

```python
dq5_tmp = df.copy()
dq5 = dq5_tmp.merge(df_zones,left_on='PULocationID', right_on="LocationID", how='left' )
date_q5 = pd.to_datetime(['2025-11-18'])
dq5 = dq5[dq5['lpep_pickup_datetime'].dt.normalize().isin(date_q5)]
dq5 = dq5.groupby(['Zone'], as_index=False).agg(total_monto=("total_amount", "sum")).sort_values("total_monto", ascending=False)
```

**Answer:** East Harlem North

### Question 6. Largest tip

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's `tip` , not `trip`. We need the name of the zone, not the ID.

- JFK Airport
- Yorkville West
- East Harlem North
- LaGuardia Airport

**Solution (SQL - Recommended):**

```sql
SELECT dz2."Zone" AS drop_off_zone, SUM(g.tip_amount) AS total_tip
FROM green_taxi_trips g
JOIN zones dz ON g."PULocationID" = dz."LocationID"
JOIN zones dz2 ON g."DOLocationID" = dz2."LocationID"
WHERE dz."Zone" = 'East Harlem North'
GROUP BY dz2."Zone"
ORDER BY total_tip DESC
LIMIT 1;
```

**Solution (Python - as implemented in notebook):**

```python
dq6 = dq5_tmp.merge(df_zones,left_on='PULocationID', right_on="LocationID", how='left' )
zone_pu_q6 = ['East Harlem North']
dq6 = dq6[dq6['Zone'].isin(zone_pu_q6)]
dq6 = dq6.merge(df_zones,left_on='DOLocationID', right_on="LocationID", how='left' )
max_tip = dq6['tip_amount'].idxmax()
zone_max_tip = dq6.loc[max_tip]
print(zone_max_tip.Zone_y)
```

**Answer:** East Harlem North

### Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:

1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:

- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- terraform init, terraform apply -auto-approve, terraform destroy
- terraform import, terraform apply -y, terraform rm

**Answer:** terraform init, terraform apply -auto-approve, terraform destroy

## Terraform Setup (Optional)

For the Terraform section:

1. Install Terraform
2. Copy Terraform files from the course repo
3. Modify variables.tf with your GCP project details
4. Run:

```bash
terraform init
terraform plan
terraform apply
```

## Files in this Repository

- `docker-compose.yaml`: Docker Compose configuration for PostgreSQL and pgAdmin
- `Dockerfile`: Custom Docker image for the application
- `ingest_data_taxi_trips_11_2025.py`: Script to ingest parquet taxi trip data into PostgreSQL
- `ingest_data_taxi_trips_2019.py`: Script to ingest taxi trip data (original version)
- `ingest_data_zones.py`: Script to ingest zone lookup CSV data into PostgreSQL
- `queries.sql`: SQL queries for the homework questions (main solutions)
- `run_pipeline_homework_01.bat`: Batch script to orchestrate the entire pipeline setup
- `requirements.txt`: Python dependencies
- `data/`: Directory for data files
- `notebooks/`: Jupyter notebooks for data exploration, including `notebook_homework_01.ipynb` with Python solutions
- `img/`: Screenshots and images

## Submitting the Solutions

Submit your solutions via the form: https://courses.datatalks.club/de-zoomcamp-2026/homework/hw1

Make sure to include a link to this repository.

## Learning in Public

We encourage sharing your learning journey! Post about your progress on LinkedIn or Twitter using the examples provided in `homework-questions.md`.
