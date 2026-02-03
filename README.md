
# Data Engineering Zoomcamp — Progress Summary

This repository collects the work and exercises from the Data Engineering Zoomcamp.
It contains Docker setups, ingestion scripts, orchestration flows, notebooks, and simple transformations used during the course.

## Where to look
- `01-week/` — Docker + Postgres exercises, ingestion scripts, homework solutions, and transformation scripts.
- `02-week/` — Workflow orchestration examples and flow definitions (Airflow/Kestra style), Postgres orchestration examples.
- `03-week/03-data-warehouse/` — Data warehouse examples and helper scripts for moving web data to GCS.
- `05-week/` — PySpark notebooks and examples for processing larger datasets.
- `base-env/` — Base Docker environment used across labs.

## Progress / Advances
- Bootstrapped local environments with Docker and Postgres for ingest experiments.
- Implemented CSV/Parquet ingestion scripts into Postgres and local files (see `01-week/`).
- Built and experimented with simple orchestration flows in `02-week/flows` to schedule ingestion and transformations.
- Explored data-warehouse patterns and cloud ingestion helpers in `03-week/03-data-warehouse`.
- Created PySpark notebooks and examples for distributed processing in `05-week/`.

## Quick start
1. Install Docker Desktop and ensure it is running.
2. From the root of this repository, start services where appropriate using the included `docker-compose.yml` files (examples live in subfolders):

```powershell
cd 01-week/2_docker_sql
docker-compose up -d
```

3. Run ingestion scripts from the notebooks or Python files in each week folder (for example, `ingest_data.py` in `01-week/2_docker_sql`).

## Next steps
- Add short README files inside each week folder describing how to run those specific labs.
- Add automated tests or simple run scripts to validate ingestion pipelines.
- Optionally containerize and parameterize notebooks for reproducible runs.

## Contact / Notes
This README summarizes the current state and progress. If you want, I can:
- Add per-week README files with run commands.
- Create a single wrapper script to run common demos.

--
Updated: Progress notes added to this repository's root README.
