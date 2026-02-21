import duckdb
import requests
from pathlib import Path

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv"


def download_and_convert_fhv():
    taxi_type = "fhv"
    data_dir = Path("data") / taxi_type
    data_dir.mkdir(exist_ok=True, parents=True)

    for year in [2019]:
        for month in range(1, 13):

            parquet_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.parquet"
            parquet_filepath = data_dir / parquet_filename

            # Skip if already converted
            if parquet_filepath.exists():
                print(f"Skipping {parquet_filename} (already exists)")
                continue

            csv_gz_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
            csv_gz_filepath = data_dir / csv_gz_filename

            download_url = f"{BASE_URL}/{csv_gz_filename}"

            print(f"Downloading {csv_gz_filename}...")
            response = requests.get(download_url, stream=True)
            response.raise_for_status()

            with open(csv_gz_filepath, "wb") as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Converting {csv_gz_filename} to Parquet...")

            con = duckdb.connect()
            con.execute(f"""
                COPY (
                    SELECT * 
                    FROM read_csv_auto('{csv_gz_filepath}',
                        ignore_errors=true,
                        strict_mode=false,
                        encoding='latin-1'
                    )
                )
                TO '{parquet_filepath}' (FORMAT PARQUET)
            """)
            con.close()

            # Remove CSV to save space
            csv_gz_filepath.unlink()

            print(f"Completed {parquet_filename}")


def create_duckdb_table():
    print("Creating prod.fhv_tripdata table in DuckDB...")

    con = duckdb.connect("taxi_rides_ny.duckdb")
    con.execute("CREATE SCHEMA IF NOT EXISTS prod")

    con.execute("""
        CREATE OR REPLACE TABLE prod.fhv_tripdata AS
        SELECT *
        FROM read_parquet('data/fhv/*.parquet', union_by_name=true)
    """)

    con.close()

    print("Table prod.fhv_tripdata created successfully.")


def update_gitignore():
    gitignore_path = Path(".gitignore")
    content = gitignore_path.read_text() if gitignore_path.exists() else ""

    if "data/" not in content:
        with open(gitignore_path, "a") as f:
            f.write("\n# Data directory\ndata/\n" if content else "# Data directory\ndata/\n")


if __name__ == "__main__":
    update_gitignore()
    download_and_convert_fhv()
    create_duckdb_table()