import json
import time 
import pandas as pd
from kafka import KafkaProducer


def json_serializer(data):
    return json.dumps(data).encode('utf-8')




if __name__ == '__main__':
    df = pd.read_csv('green_tripdata_2019-10.csv')
    df_green = df[[ 'lpep_pickup_datetime', 
                    'lpep_dropoff_datetime',
                    'PULocationID',
                    'DOLocationID',
                    'passenger_count',
                    'trip_distance',
                    'tip_amount' ]]
    
    server = 'localhost:9092'

    producer = KafkaProducer(
        bootstrap_servers=[server],
        value_serializer=json_serializer)
    
    producer.bootstrap_connected()

    t0 = time.time()

    topic_name = 'green-trips'

    for row in df_green.itertuples(index=False):
        row_dict = {col: getattr(row, col) for col in row._fields}
        producer.send(topic_name, value=row_dict)
        print(f"Sent: {row_dict}")

    producer.flush()

    t1 = time.time()
    print(f'took {(t1 - t0):.2f} seconds')