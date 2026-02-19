import duckdb

con = duckdb.connect("taxi_rides_ny.duckdb")

print("Schemas:")
print(con.sql("SELECT schema_name FROM information_schema.schemata").fetchall())

print("Tables in prod:")
print(con.sql("""
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'prod'
""").fetchall())

print("Row count yellow:")
print(con.sql("SELECT COUNT(*) FROM prod.yellow_tripdata").fetchall())

con.close()
