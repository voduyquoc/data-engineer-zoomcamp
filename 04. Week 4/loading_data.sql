CREATE TABLE ny-rides-quocvo.trips_data_all.green_tripdata AS
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2019`;

CREATE TABLE ny-rides-quocvo.trips_data_all.yellow_tripdata AS
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2019`;

INSERT INTO ny-rides-quocvo.trips_data_all.green_tripdata
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2020`;

INSERT INTO ny-rides-quocvo.trips_data_all.yellow_tripdata
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2020`;

-- When you run the query, only run 5 of the ALTER TABLE statements at one time (by highlighting only 5). 
-- Otherwise BigQuery will say too many alterations to the table are being made.

 -- Fixes yellow table schema
ALTER TABLE `ny-rides-quocvo.trips_data_all.yellow_tripdata`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `ny-rides-quocvo.trips_data_all.yellow_tripdata`
  RENAME COLUMN pickup_datetime TO tpep_pickup_datetime;
ALTER TABLE `ny-rides-quocvo.trips_data_all.yellow_tripdata`
  RENAME COLUMN dropoff_datetime TO tpep_dropoff_datetime;
ALTER TABLE `ny-rides-quocvo.trips_data_all.yellow_tripdata`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `ny-rides-quocvo.trips_data_all.yellow_tripdata`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;
ALTER TABLE `ny-rides-quocvo.trips_data_all.yellow_tripdata`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `ny-rides-quocvo.trips_data_all.yellow_tripdata`
  RENAME COLUMN dropoff_location_id TO DOLocationID;

  -- Fixes green table schema
ALTER TABLE `ny-rides-quocvo.trips_data_all.green_tripdata`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `ny-rides-quocvo.trips_data_all.green_tripdata`
  RENAME COLUMN pickup_datetime TO lpep_pickup_datetime;
ALTER TABLE `ny-rides-quocvo.trips_data_all.green_tripdata`
  RENAME COLUMN dropoff_datetime TO lpep_dropoff_datetime;
ALTER TABLE `ny-rides-quocvo.trips_data_all.green_tripdata`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `ny-rides-quocvo.trips_data_all.green_tripdata`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;
ALTER TABLE `ny-rides-quocvo.trips_data_all.green_tripdata`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `ny-rides-quocvo.trips_data_all.green_tripdata`
  RENAME COLUMN dropoff_location_id TO DOLocationID;


-- Homework
CREATE OR REPLACE EXTERNAL TABLE `ny-rides-quocvo.trips_data_all.external_fhv_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://fhv_data_2019_dqv/fhv_tripdata_2019-*.csv'] 
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE ny-rides-quocvo.trips_data_all.fhv_tripdata AS
SELECT * FROM ny-rides-quocvo.trips_data_all.external_fhv_tripdata;


{% set models_to_generate = codegen.get_models(directory='core', prefix='') %}
{{ codegen.generate_model_yaml(
    model_names = models_to_generate
) }}