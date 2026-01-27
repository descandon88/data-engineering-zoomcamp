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
    parquet_file = params.parquet_file

    # Read parquet file
    print(f"Reading parquet file: {parquet_file}")
    df = pd.read_parquet(parquet_file, engine='pyarrow')

    # Normalize datetime columns to date
    datetime_cols = df.select_dtypes(include=['datetime64[ns]', 'datetime64[ns, UTC]']).columns
    for col in datetime_cols:
        df[col] = df[col].dt.normalize()

    print(f"DataFrame shape: {df.shape}")
    print(f"Columns: {df.columns.tolist()}")

    # Create engine
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # Insert data in chunks
    chunk_size = 100000
    total_rows = len(df)
    print(f"Inserting {total_rows} rows into {table_name} in chunks of {chunk_size}")

    start_time = time()
    for i in range(0, total_rows, chunk_size):
        chunk = df.iloc[i:i+chunk_size]
        if i == 0:
            # Create table on first chunk
            chunk.head(0).to_sql(name=table_name, con=engine, if_exists='replace', index=False)
        chunk.to_sql(name=table_name, con=engine, if_exists='append', index=False)
        print(f"Inserted chunk {i//chunk_size + 1} of {total_rows//chunk_size + 1}")

    end_time = time()
    print(f"Insertion completed in {end_time - start_time:.2f} seconds")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest parquet data to Postgres')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True, help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True, help='database name for postgres')
    parser.add_argument('--table_name', required=True, help='name of the table where we will write the results to')
    parser.add_argument('--parquet_file', required=True, help='path to the parquet file')

    args = parser.parse_args()

    main(args)