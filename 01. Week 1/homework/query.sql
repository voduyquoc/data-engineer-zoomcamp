
/* Count records
How many taxi trips were totally made on September 18th 2019?
Tip: started and finished on 2019-09-18.
Remember that lpep_pickup_datetime and lpep_dropoff_datetime columns are in the format timestamp (date and hour+min+sec) and not in date.*/

SELECT
  CAST (lpep_pickup_datetime AS DATE) as pickup_date,
  CAST (lpep_dropoff_datetime AS DATE) as dropoff_date,
  COUNT(1)
FROM green_taxi_trips
GROUP BY pickup_date, dropoff_date
HAVING CAST (lpep_pickup_datetime AS DATE) = '2019-09-18';


/* Largest trip for each day
Which was the pick up day with the largest trip distance Use the pick up time for your calculations.*/

SELECT
  CAST (lpep_pickup_datetime AS DATE) as pickup_date,
  MAX(trip_distance) as max_distance
FROM green_taxi_trips
GROUP BY pickup_date
ORDER BY max_distance DESC;

/* Three biggest pick up Boroughs
Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?*/

SELECT 
  t2."Borough",
  SUM(t1.total_amount)
FROM green_taxi_trips t1
JOIN zones t2 ON t1."PULocationID" = t2."LocationID"
WHERE CAST(t1.lpep_pickup_datetime AS DATE) = '2019-09-18'
GROUP BY t2."Borough"
HAVING SUM(t1.total_amount) >= 50000;

/* Largest tip
For the passengers picked up in September 2019 in the zone name Astoria 
which was the drop off zone that had the largest tip? 
We want the name of the zone, not the id.
Note: it's not a typo, it's tip , not trip */

SELECT 
  EXTRACT ('MONTH' FROM lpep_pickup_datetime) AS month,  
  zpu."Zone" AS pickup_zone,
  zdo."Zone" AS dropoff_zone,
  MAX(t.tip_amount)
FROM green_taxi_trips t
JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
WHERE zpu."Zone" = 'Astoria'
GROUP BY month, pickup_zone, dropoff_zone
ORDER BY MAX(t.tip_amount) DESC;

