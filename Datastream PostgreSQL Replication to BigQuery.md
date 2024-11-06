## Datastream PostgreSQL Replication to BigQuery [SOLUTION]

Fill and run this following command in Cloud Shell
```
export REGION=
```
```
export IP_ADDRESS=
```

Copy this following command and run in Cloud Shell
```
gcloud services enable sqladmin.googleapis.com

POSTGRES_INSTANCE=postgres-db
DATASTREAM_IPS=$IP_ADDRESS
gcloud sql instances create ${POSTGRES_INSTANCE} \
    --database-version=POSTGRES_14 \
    --cpu=2 --memory=10GB \
    --authorized-networks=${DATASTREAM_IPS} \
    --region=$REGION \
    --root-password pwd \
    --database-flags=cloudsql.logical_decoding=on

gcloud sql connect postgres-db --user=postgres
```

Copy this following command and run in Cloud Shell
```
CREATE SCHEMA IF NOT EXISTS test;

CREATE TABLE IF NOT EXISTS test.example_table (
id  SERIAL PRIMARY KEY,
text_col VARCHAR(50),
int_col INT,
date_col TIMESTAMP
);

ALTER TABLE test.example_table REPLICA IDENTITY DEFAULT; 

INSERT INTO test.example_table (text_col, int_col, date_col) VALUES
('hello', 0, '2020-01-01 00:00:00'),
('goodbye', 1, NULL),
('name', -987, NOW()),
('other', 2786, '2021-01-01 00:00:00');

CREATE PUBLICATION test_publication FOR ALL TABLES;
ALTER USER POSTGRES WITH REPLICATION;
SELECT PG_CREATE_LOGICAL_REPLICATION_SLOT('test_replication', 'pgoutput');

\q
```

Fill this value and run in Cloud Shell
```
export HOSTNAME=
```

Copy this following command and run in Cloud Shell
```
gcloud services enable datastream.googleapis.com

gcloud datastream connection-profiles create postgres-cp \
  --location=$REGION \
  --display-name="postgres-cp" \
  --type=postgresql \
  --postgresql-hostname=$HOSTNAME \
  --postgresql-port=5432 \
  --postgresql-username=postgres \
  --postgresql-password=pwd \
  --postgresql-database=postgres \
  --static-ip-connectivity

gcloud datastream connection-profiles create bigquery-cp \
  --location=$REGION \
  --display-name="bigquery-cp" \
  --type=bigquery

cat << EOF > source_config.json
  {
    "includeObjects": {"postgresqlSchemas": [
        {
          "schema": "test",
        }]},
    "excludeObjects": {},
    "replicationSlot": "test_replication",
    "publication": "test_publication"
  }
EOF

cat << EOF > destination_config.json
{
  "singleTargetDataset": {
    "datasetId": "$(gcloud config get-value project):test"
  },
  "dataFreshness": "0s"
}
EOF

gcloud datastream streams create test-stream \
  --location=$REGION \
  --display-name="test-stream" \
  --source=postgres-cp \
  --postgresql-source-config=source_config.json \
  --destination=bigquery-cp \
  --bigquery-destination-config=destination_config.json \
  --backfill-none
```

## Congratulations !! 
