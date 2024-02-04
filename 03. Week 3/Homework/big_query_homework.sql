-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `ny-rides-quocvo.ny_taxi.external_green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://green_taxi_2022_dqv/green_tripdata_2022-*.parquet']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE ny-rides-quocvo.ny_taxi.green_tripdata_non_partitoned AS
SELECT * FROM ny-rides-quocvo.ny_taxi.external_green_tripdata;

-- What is count of records for the 2022 Green Taxi Data?
SELECT count(*) FROM `ny-rides-quocvo.ny_taxi.green_tripdata_non_partitoned`;
SELECT count(*) FROM `ny-rides-quocvo.ny_taxi.external_green_tripdata`;

-- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
-- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
SELECT COUNT(DISTINCT(PULocationID)) FROM `ny-rides-quocvo.ny_taxi.green_tripdata_non_partitoned`;
SELECT COUNT(DISTINCT(PULocationID)) FROM `ny-rides-quocvo.ny_taxi.external_green_tripdata`;

-- How many records have a fare_amount of 0?
SELECT COUNT(*) FROM `ny-rides-quocvo.ny_taxi.green_tripdata_non_partitoned`
WHERE fare_amount = 0;

-- Creating a partition and cluster table from external table
CREATE OR REPLACE TABLE `ny-rides-quocvo.ny_taxi.green_tripdata_partitoned_clustered_1`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS (
  SELECT * FROM `ny-rides-quocvo.ny_taxi.external_green_tripdata`);


-- Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive) for non-partitioned table
-- Query scans 12.82 MB
SELECT COUNT(DISTINCT(PULocationID))
FROM ny-rides-quocvo.ny_taxi.green_tripdata_non_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive) for partitioned table
-- Query scans 1.12 MB
SELECT COUNT(DISTINCT(PULocationID))
FROM ny-rides-quocvo.ny_taxi.green_tripdata_partitoned_clustered_1
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
SELECT COUNT(*) FROM ny-rides-quocvo.ny_taxi.green_tripdata_non_partitoned;