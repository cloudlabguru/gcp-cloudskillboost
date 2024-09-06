## Classify Images with TensorFlow on Google Cloud: Challenge Lab [SOLUTION]

Fill the value and run this script in CloudShell
```
export ZONE=
```

Run this script in CloudShell
```
gcloud services enable \
  compute.googleapis.com \
  monitoring.googleapis.com \
  logging.googleapis.com \
  notebooks.googleapis.com \
  aiplatform.googleapis.com \
  artifactregistry.googleapis.com \
  container.googleapis.com

gcloud notebooks instances create cnn-challenge \
  --location=$ZONE \
  --vm-image-project=deeplearning-platform-release \
  --vm-image-family=tf-2-11-cu113-notebooks \
  --machine-type=e2-standard-2
```

In JupyterLab terminal, run this script
```
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
```

## Congratulations !! 
