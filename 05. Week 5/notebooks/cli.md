gsutil cp 11_spark_sql.py  gs://ny-rides-quocvo/code/11_spark_sql.py 

--input_green=gs://ny-rides-quocvo/pq/green/2020/*/
--input_yellow=gs://ny-rides-quocvo/pq/yellow/2020/*/
--output=gs://ny-rides-quocvo/report-2020

Add dataproc admin role for service account in GCP

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster-vdq \
    --region=us-central1 \
    gs://ny-rides-quocvo/code/11_spark_sql.py \
    -- \
        --input_green=gs://ny-rides-quocvo/pq/green/2019/*/ \
        --input_yellow=gs://ny-rides-quocvo/pq/yellow/2019/*/ \
        --output=gs://ny-rides-quocvo/report-2019


gsutil cp 12_spark_sql_bigquery.py  gs://ny-rides-quocvo/code/12_spark_sql_bigquery.py

gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster-vdq \
    --region=us-central1 \
    --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
    gs://ny-rides-quocvo/code/12_spark_sql_bigquery.py \
    -- \
        --input_green=gs://ny-rides-quocvo/pq/green/2019/*/ \
        --input_yellow=gs://ny-rides-quocvo/pq/yellow/2019/*/ \
        --output=trips_data_all.reports-2019