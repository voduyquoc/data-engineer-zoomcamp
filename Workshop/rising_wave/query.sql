SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    taxi_zone_pu.Zone as pickup_zone,
    taxi_zone_do.Zone as dropoff_zone,
    trip_distance,
    tpep_dropoff_datetime - tpep_pickup_datetime as trip_time
FROM
    trip_data
        JOIN taxi_zone as taxi_zone_pu
            ON trip_data.PULocationID = taxi_zone_pu.location_id
        JOIN taxi_zone as taxi_zone_do
            ON trip_data.DOLocationID = taxi_zone_do.location_id
LIMIT 10;


CREATE MATERIALIZED VIEW trip_time_table AS SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    taxi_zone_pu.Zone as pickup_zone,
    taxi_zone_do.Zone as dropoff_zone,
    trip_distance,
    tpep_dropoff_datetime - tpep_pickup_datetime as trip_time
FROM
    trip_data
        JOIN taxi_zone as taxi_zone_pu
            ON trip_data.PULocationID = taxi_zone_pu.location_id
        JOIN taxi_zone as taxi_zone_do
            ON trip_data.DOLocationID = taxi_zone_do.location_id;


SELECT
    pickup_zone,
    dropoff_zone,
    AVG(trip_time) as average_trip_time
FROM
    trip_time_table
GROUP BY
    pickup_zone, dropoff_zone
ORDER BY
    average_trip_time DESC
LIMIT 10;

SELECT
    pickup_zone,
    dropoff_zone,
    AVG(trip_time) as average_trip_time,
    COUNT(1) as number_of_trip
FROM
    trip_time_table
GROUP BY
    pickup_zone, dropoff_zone
ORDER BY
    average_trip_time DESC
LIMIT 10;

SELECT
    pickup_zone,
    dropoff_zone,
    trip_time,
    tpep_pickup_datetime,
    tpep_dropoff_datetime
FROM
    trip_time_table
WHERE
    pickup_zone = 'Yorkville East'
AND
    dropoff_zone = 'Steinway';


CREATE MATERIALIZED VIEW latest_pickup_time AS
    WITH t AS (
        SELECT MAX(tpep_pickup_datetime) AS latest_pickup_time
        FROM trip_data
    )
    SELECT taxi_zone.Zone as taxi_zone, latest_pickup_time
    FROM t,
            trip_data
    JOIN taxi_zone
        ON trip_data.PULocationID = taxi_zone.location_id
    WHERE trip_data.tpep_pickup_datetime = t.latest_pickup_time;


SELECT
    taxi_zone.Zone AS pickup_zone,
    count(*) AS last_17_hours_pickup_cnt
FROM
    latest_pickup_time as t,
    trip_data
        JOIN taxi_zone
            ON trip_data.PULocationID = taxi_zone.location_id
WHERE
    trip_data.tpep_pickup_datetime > (t.latest_pickup_time - INTERVAL '17' HOUR)
GROUP BY
    taxi_zone.Zone
ORDER BY last_17_hours_pickup_cnt DESC
    LIMIT 10;

