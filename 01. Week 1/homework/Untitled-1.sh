winpty docker run -it --entrypoint=bash python:3.9

winpty docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v "d:/Learning/05. Data engineering/00. Zoomcamp/01. Week 1/homework/ny_taxi_postgres_data:/var/lib/postgresql/data" \
  -p 5432:5432 \
  postgres:13

wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz

wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv

winpty pgcli -h localhost -U root -d ny_taxi

winpty docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  dpage/pgadmin4

winpty docker network create pg-network-homework

winpty docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v "d:/Learning/05. Data engineering/00. Zoomcamp/01. Week 1/homework/ny_taxi_postgres_data:/var/lib/postgresql/data" \
  -p 5432:5432 \
  --network=pg-network-homework \
  --name pg-database-homework \
  postgres:13

winpty docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network-homework \
  --name pgadmin-homework \
  dpage/pgadmin4

python -m notebook

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"

winpty python ingest-data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_trips \
  --url=${URL}

winpty docker build -t taxi_ingest:v002 .

winpty docker run -it \
  --network=pg-network-homework \
  taxi_ingest:v002 \
  --user=root \
  --password=root \
  --host=pg-database-homework \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_trips \
  --url=${URL}


winpty docker-compose up 

winpty docker-compose up -d

docker-compose down

# Run after compose, need to check network name
winpty docker run -it \
  --network=homework_default \
  taxi_ingest:v002 \
  --user=root \
  --password=root \
  --host=pgdatabase \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_trips \
  --url=${URL}


# terraform
terraform fmt

terraform init

terraform plan

terraform apply

terraform destroy