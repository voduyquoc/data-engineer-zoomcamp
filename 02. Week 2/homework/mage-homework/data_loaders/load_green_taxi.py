import pandas as pd

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data(*args, **kwargs):
    """
    Template for loading data from API
    """

    year = '2020'
    month = ['10', '11', '12']
    url_base = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_'

    taxi_dtypes = {
        'VendorID': pd.Int64Dtype(),
        'passenger_count': pd.Int64Dtype(),
        'trip_distance': float,
        'RatecodeID': pd.Int64Dtype(),
        'store_and_fwd_flag': str,
        'PULocationID': pd.Int64Dtype(),
        'DOLocationID': pd.Int64Dtype(),
        'payment_type': pd.Int64Dtype(),
        'fare_amount': float,
        'extra': float,
        'mta_tax': float,
        'tip_amount': float,
        'tolls_amount': float,
        'improvement_surcharge': float,
        'total_amount': float,
        'congestion_surcharge': float 
    }

    parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']

    df = pd.DataFrame()

    for m in month:
        url_path = url_base + year + '-' + m + '.csv.gz'
        temp_df = pd.read_csv(url_path, sep=",", compression="gzip", dtype=taxi_dtypes, parse_dates=parse_dates)
        df = pd.concat([df, temp_df], ignore_index=True)
    print(f"The shape of the data: {df.shape[0]} rows and {df.shape[1]} columns.")
    print(f"The number of lines has NA VendorID: {df['VendorID'].isna().sum()}")
    print(f"The existing value in column VendorID: {df['VendorID'].unique()}")
    return df


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
