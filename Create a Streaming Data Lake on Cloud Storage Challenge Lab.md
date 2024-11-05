## Create a Streaming Data Lake on Cloud Storage: Challenge Lab [SOLUTION]

Fill and run this following command in Cloud Shell
```
export TOPIC_ID=
```
```
export MESSAGE=""
```
```
export REGION=
```

Run this following command in Cloud Shell
```
gcloud config set compute/region $REGION

gcloud services disable dataflow.googleapis.com
gcloud services enable \
dataflow.googleapis.com \
cloudscheduler.googleapis.com

sleep 30

PROJECT_ID=$(gcloud config get-value project)
BUCKET_NAME="${PROJECT_ID}-bucket"

gsutil mb gs://$BUCKET_NAME

gcloud pubsub topics create $TOPIC_ID

# Set the App Engine region variable
if [ "$REGION" == "us-central1" ]; then
  gcloud app create --region us-central
elif [ "$REGION" == "europe-west1" ]; then
  gcloud app create --region europe-west
else
  gcloud app create --region "$REGION"
fi
 
gcloud scheduler jobs create pubsub publisher-job --schedule="* * * * *" \
    --topic=$TOPIC_ID --message-body="$MESSAGE"

#!/bin/bash

while true; do
    if gcloud scheduler jobs run publisher-job --location="$REGION"; then
        echo "Command executed successfully. Now running next command.."
        break 
    else
        echo "Retrying.. "
        sleep 10 
    fi
done

cat > command.sh <<EOF_CP
#!/bin/bash

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/pubsub/streaming-analytics
pip install -U -r requirements.txt
python PubSubToGCS.py \
--project=$PROJECT_ID \
--region=$REGION \
--input_topic=projects/$PROJECT_ID/topics/$TOPIC_ID \
--output_path=gs://$BUCKET_NAME/samples/output \
--runner=DataflowRunner \
--window_size=2 \
--num_shards=2 \
--temp_location=gs://$BUCKET_NAME/temp
EOF_CP

chmod +x command.sh

docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID -e BUCKET_NAME=$BUCKET_NAME -e PROJECT_ID=$PROJECT_ID -e REGION=$REGION -e TOPIC_ID=$TOPIC_ID -v $(pwd)/command.sh:/command.sh python:3.7 /bin/bash -c "/command.sh"
```

## Congratulations !! 
