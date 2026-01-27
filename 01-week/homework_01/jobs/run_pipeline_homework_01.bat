@echo off
REM Pipeline Orchestration Script for Module 1 Homework (Windows)
REM This script sets up the environment, downloads data, starts Docker containers,
REM ingests data into PostgreSQL, and runs SQL queries

echo ========================================
echo Module 1 Homework Pipeline Orchestration
echo ========================================

REM Change to the parent directory (homework_01 root)
cd /d "%~dp0.."

REM Step 1: Create data directory if it doesn't exist
if not exist "data" mkdir data

REM Step 2: Download data files
echo Downloading data files...
if not exist "data\green_tripdata_2025-11.parquet" (
    echo Downloading green taxi trips data...
    curl -L -o data\green_tripdata_2025-11.parquet https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet
) else (
    echo Green taxi data already exists.
)

if not exist "data\ntaxi_zone_lookup.csv" (
    echo Downloading zone lookup data...
    curl -L -o data\ntaxi_zone_lookup.csv https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
) else (
    echo Zone lookup data already exists.
)

REM Step 3: Start Docker containers
echo Starting Docker containers...
docker-compose up -d

REM Wait for PostgreSQL to be ready
echo Waiting for PostgreSQL to be ready...
timeout /t 10 /nobreak > nul

REM Step 4: Install Python dependencies
echo Installing Python dependencies...
pip install -r requirements.txt

REM Step 5: Ingest data into PostgreSQL
echo Ingesting taxi trip data...
python transformations\ingest_data_taxi_trips_11_2025.py --user=postgres --password=postgres --host=localhost --port=5433 --db=ny_taxi --table_name=green_taxi_trips --parquet_file=data\green_tripdata_2025-11.parquet

echo Ingesting zone lookup data...
python transformations\ingest_data_zones.py --user=postgres --password=postgres --host=localhost --port=5433 --db=ny_taxi --table_name=zones --csv_file=data\ntaxi_zone_lookup.csv

REM Step 6: Run SQL queries (optional - you can run these manually in pgAdmin)
echo Data ingestion complete!
echo You can now run the SQL queries from sql_files\queries_homework_01.sql in pgAdmin or pgcli
echo.
echo To connect to the database:
echo Host: localhost
echo Port: 5433
echo Database: ny_taxi
echo User: postgres
echo Password: postgres
echo.
echo pgAdmin is available at: http://localhost:8080
echo Email: pgadmin@pgadmin.com
echo Password: pgadmin

echo ========================================
echo Pipeline orchestration complete!
echo ========================================

pause