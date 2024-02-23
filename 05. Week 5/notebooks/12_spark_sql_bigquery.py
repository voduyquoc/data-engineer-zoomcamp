#!/usr/bin/env python
# coding: utf-8

# gcloud dataproc jobs submit pyspark \
#     --cluster=de-zoomcamp-cluster-vdq \
#     --region=us-central1 \
##    --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
#     gs://ny-rides-quocvo/code/12_spark_sql_bigquery.py \
#     -- \
#         --input_green=gs://ny-rides-quocvo/pq/green/2019/*/ \
#         --input_yellow=gs://ny-rides-quocvo/pq/yellow/2019/*/ \
#         --output=trips_data_all.reports-2019



import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

import argparse

parser = argparse.ArgumentParser()

parser.add_argument('--input_green', required=True)
parser.add_argument('--input_yellow', required=True)
parser.add_argument('--output', required=True)

args = parser.parse_args()

input_green = args.input_green
input_yellow = args.input_yellow
output = args.output


spark = SparkSession.builder \
    .appName('test') \
    .getOrCreate()

spark.conf.set('temporaryGcsBucket', 'dataproc-temp-us-central1-409943381188-1ry24rat')

df_green = spark.read.parquet(input_green)
df_yellow = spark.read.parquet(input_yellow)

df_green = df_green \
    .withColumnRenamed('lpep_pickup_datetime', 'pickup_datetime') \
    .withColumnRenamed('lpep_dropoff_datetime', 'dropoff_datetime')
    
df_yellow = df_yellow \
    .withColumnRenamed('tpep_pickup_datetime', 'pickup_datetime') \
    .withColumnRenamed('tpep_dropoff_datetime', 'dropoff_datetime')

common_columns = ['VendorID',
                'pickup_datetime',
                'dropoff_datetime',
                'store_and_fwd_flag',
                'RatecodeID',
                'PULocationID',
                'DOLocationID',
                'passenger_count',
                'trip_distance',
                'fare_amount',
                'extra',
                'mta_tax',
                'tip_amount',
                'tolls_amount',
                'improvement_surcharge',
                'total_amount',
                'payment_type',
                'congestion_surcharge']

df_green_sel = df_green \
    .select(common_columns) \
    .withColumn('service_type', F.lit('green'))
    
df_yellow_sel = df_yellow \
    .select(common_columns) \
    .withColumn('service_type', F.lit('yellow'))

df_trips_data = df_green_sel.unionAll(df_yellow_sel)

df_trips_data.registerTempTable('trips_data')

df_result = spark.sql("""
SELECT 
    -- Reveneue grouping 
    PULocationID AS revenue_zone,
    date_trunc('month', pickup_datetime) AS revenue_month, 
    service_type, 

    -- Revenue calculation 
    SUM(fare_amount) AS revenue_monthly_fare,
    SUM(extra) AS revenue_monthly_extra,
    SUM(mta_tax) AS revenue_monthly_mta_tax,
    SUM(tip_amount) AS revenue_monthly_tip_amount,
    SUM(tolls_amount) AS revenue_monthly_tolls_amount,
    SUM(improvement_surcharge) AS revenue_monthly_improvement_surcharge,
    SUM(total_amount) AS revenue_monthly_total_amount,
    SUM(congestion_surcharge) AS revenue_monthly_congestion_surcharge,

    -- Additional calculations
    AVG(passenger_count) AS avg_montly_passenger_count,
    AVG(trip_distance) AS avg_montly_trip_distance
FROM
    trips_data
GROUP BY
    1, 2, 3
""")

df_result.write.format('bigquery') \
    .option('table', output) \
    .save()