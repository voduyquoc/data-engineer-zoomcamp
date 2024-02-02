if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    data.columns = (data.columns
                    .str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True)
                    .str.lower())
    
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

    return data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]


@test
def test_output_1(output, *args) -> None:
    assert output['passenger_count'].isin([0]).sum() == 0, 'The output is included zero passenger lines.'

@test
def test_output_2(output, *args) -> None:
    assert output['trip_distance'].isin([0]).sum() == 0, 'The output is included zero distance trips.'

@test
def test_output_3(output, *args) -> None:
    assert "vendor_id" in output.columns, 'The output is not included vendor_id column.'

