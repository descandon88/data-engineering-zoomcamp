# FROM python:3.13

# RUN apt-get install wget
# RUN  pip install pandas sqlalchemy psycopg2

# WORKDIR /app
# COPY ingest_data_taxi_trips_2019.py ingest_data_taxi_trips_2019.py 

# ENTRYPOINT [ "python", "ingest_data_taxi_trips_2019.py" ]
FROM jupyter/base-notebook:python-3.11

WORKDIR /home/jovyan

# Copiamos requirements
COPY requirements.txt .

# Instalamos dependencias (con uv)
RUN pip install --no-cache-dir uv \
    && uv pip install --system -r requirements.txt

# permisos correctos
USER root
RUN chown -R jovyan:users /home/jovyan
USER jovyan
