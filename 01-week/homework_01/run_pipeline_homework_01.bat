#!/bin/bash
# Pipeline Orchestration Script for Module 1 Homework
# This script sets up the environment, downloads data, starts Docker containers,
# ingests data into PostgreSQL, and runs SQL queries

echo "========================================"
echo "Module 1 Homework Pipeline Orchestration"
echo "========================================"



# Step 1: Start Docker containers
echo "Starting Docker containers..."
docker-compose up -d

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 10

# Step 2: Install Python dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Step 3: Ingest data into PostgreSQL
echo "Ingesting taxi trip data..."
python ingest_data_taxi_trips_11_2025.py --user=postgres --password=postgres --host=localhost --port=5433 --db=ny_taxi --table_name=green_taxi_trips --parquet_file=data/green_tripdata_2025-11.parquet

echo "Ingesting zone lookup data..."
python ingest_data_zones.py --user=postgres --password=postgres --host=localhost --port=5433 --db=ny_taxi --table_name=zones --csv_file=data/ntaxi_zone_lookup.csv

# Step 4: Run SQL queries (optional - you can run these manually in pgAdmin)
echo "Data ingestion complete!"
echo "You can now run the SQL queries from queries.sql in pgAdmin or pgcli"
echo ""
echo "To connect to the database:"
echo "Host: localhost"
echo "Port: 5433"
echo "Database: ny_taxi"
echo "User: postgres"
echo "Password: postgres"
echo ""
echo "pgAdmin is available at: http://localhost:8080"
echo "Email: pgadmin@pgadmin.com"
echo "Password: pgadmin"

echo "========================================"
echo "Pipeline orchestration complete!"
echo "========================================"