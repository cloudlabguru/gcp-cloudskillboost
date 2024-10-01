## Develop GenAI Apps with Gemini and Streamlit: Challenge Lab [SOLUTION]

Run this following command in Vertex AI terminal
```
gsutil cp gs://spls/gsp517/prompt.ipynb .

curl -LO 
```

Then run the prompt.ipynb

### Task 4
Run this following command in Cloud Shell
```
cat >  batch_insert.py <<EOF
from google.cloud import spanner
from google.cloud.spanner_v1 import param_types
INSTANCE_ID = "banking-instance"
DATABASE_ID = "banking-db"
spanner_client = spanner.Client()
instance = spanner_client.instance(INSTANCE_ID)
database = instance.database(DATABASE_ID)
with database.batch() as batch:
    batch.insert(
        table="Customer",
        columns=("CustomerId", "Name", "Location"),
        values=[
        ('edfc683f-bd87-4bab-9423-01d1b2307c0d', 'John Elkins', 'Roy Utah'),
        ('1f3842ca-4529-40ff-acdd-88e8a87eb404', 'Martin Madrid', 'Ames Iowa'),
        ('3320d98e-6437-4515-9e83-137f105f7fbc', 'Theresa Henderson', 'Anna Texas'),
        ('6b2b2774-add9-4881-8702-d179af0518d8', 'Norma Carter', 'Bend Oregon'),
        ],
    )
print("Rows inserted")
EOF

python3 batch_insert.py
```

### Task 5
* Replace variable ```REGION``` with the given value, you can use this [website](https://www.browserling.com/tools/text-replace) <br />
* Run this following command in Cloud Shell and wait until the dataflow job succeed to get the last green tick
```
gsutil mb gs://$(gcloud config get-value project)
touch emptyfile
gsutil cp emptyfile gs://$(gcloud config get-value project)/tmp/emptyfile

gcloud services disable dataflow.googleapis.com --force
gcloud services enable dataflow.googleapis.com

sleep 100

gcloud dataflow jobs run spanner-load --gcs-location gs://dataflow-templates-REGION/latest/GCS_Text_to_Cloud_Spanner --region REGION --staging-location gs://$(gcloud config get-value project)/tmp/ --parameters instanceId=banking-instance,databaseId=banking-db,importManifest=gs://cloud-training/OCBL372/manifest.json
```

## Congratulations !! 
