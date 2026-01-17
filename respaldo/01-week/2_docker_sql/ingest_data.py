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
    table_name = params.table_name
    db = params.db
    url = params.url


    parquet_name = 'yellow_tripdata_2024-01.parquet'

    os.system(f'wget {url} -O {parquet_name}')
    #engine = create_engine("postgresql://root:root@localhost:5416/ny_taxi")
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}', echo=True)

    #df = pd.read_parquet("yellow_tripdata_2024-01.parquet", engine = 'fastparquet')
    df = pd.read_parquet(parquet_name, engine = 'fastparquet')

    len(df)
    #print(pd.io.sql.get_schema(df,name = 'yellow_taxi_data',con=engine))
    #print(pd.io.sql.get_schema(df, name = f'{table_name}',con=engine))

    #df.to_sql(name='yellow_taxi_data',con=engine, if_exists='replace')
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    #df.to_sql(name=table_name, con=engine, if_exists='append')

    #while True:
    t_start = time()
     #   df.to_sql(name='yellow_taxi_data',con=engine, if_exists='append')
    df.to_sql(name=table_name, con=engine, if_exists='append')
 
    t_end = time()
    print('inserted another chunk, took %.3f second' % (t_end-t_start))


if __name__=='__main__':

    parser = argparse.ArgumentParser(description = 'Ingest parquet data to postgres')
    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password  for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--table_name', help='name of the table where will write the results to')
    parser.add_argument('--url', help='url of the parquet file')

# parser.add_argument('integers',metavar='N',type=int,nargs='+',
  #                  help='an integer for the accumulator')

   # parser.add_argument('--sum',dest='accumulate',action='store_const',
    #                const=sum,default=max,help='sum the integers (defaults:find the max)')

    args = parser.parse_args()
    
    main(args)






