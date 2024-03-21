1.  alias rpk="docker exec -ti redpanda-1 rpk"
rpk version
v22.3.5 (rev 28b2443)

2. rpk topic create test-topic --partitions 2 --replicas 1
TOPIC       STATUS
test-topic  OK

3. True

4. Sending the messages

5. rpk topic create green-trips --partitions 2 --replicas 1
143 second

6. Row(lpep_pickup_datetime='2019-10-01 00:26:02', lpep_dropoff_datetime='2019-10-01 00:39:58', PULocationID=112, DOLocationID=196, passenger_count=1.0, trip_distance=5.88, tip_amount=0.0)

7. 74