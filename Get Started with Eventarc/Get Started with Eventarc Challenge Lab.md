## Get Started with Eventarc: Challenge Lab [SOLUTION]

Fill and run this following command in Cloud Shell
```
export LOCATION=
```

Copy this following command and run in Cloud Shell
```
gcloud services enable run.googleapis.com

gcloud services enable eventarc.googleapis.com

gcloud pubsub topics create $DEVSHELL_PROJECT_ID-topic

gcloud  pubsub subscriptions create --topic $DEVSHELL_PROJECT_ID-topic $DEVSHELL_PROJECT_ID-topic-sub

gcloud run deploy pubsub-events \
  --image=gcr.io/cloudrun/hello \
  --platform=managed \
  --region=$LOCATION \
  --allow-unauthenticated

gcloud eventarc triggers create pubsub-events-trigger \
  --location=$LOCATION \
  --destination-run-service=pubsub-events \
  --destination-run-region=$LOCATION \
  --transport-topic=$DEVSHELL_PROJECT_ID-topic \
  --event-filters="type=google.cloud.pubsub.topic.v1.messagePublished"

gcloud pubsub topics publish $DEVSHELL_PROJECT_ID-topic \
  --message="Test message"
```

## Congratulations !! 
