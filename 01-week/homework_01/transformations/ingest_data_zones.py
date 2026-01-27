#!/usr/bin/env python
# coding: utf-8

import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    csv_file = params.csv_file

    # Read CSV file
    print(f"Reading CSV file: {csv_file}")
    df = pd.read_csv(csv_file)

    print(f"DataFrame shape: {df.shape}")
    print(f"Columns: {df.columns.tolist()}")

    # Create engine
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # Insert data
    print(f"Inserting data into {table_name}")
    start_time = time()
    df.to_sql(name=table_name, con=engine, if_exists='replace', index=False)
    end_time = time()
    print(f"Insertion completed in {end_time - start_time:.2f} seconds")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True, help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True, help='database name for postgres')
    parser.add_argument('--table_name', required=True, help='name of the table where we will write the results to')
    parser.add_argument('--csv_file', required=True, help='path to the CSV file')

    args = parser.parse_args()

    main(args)
