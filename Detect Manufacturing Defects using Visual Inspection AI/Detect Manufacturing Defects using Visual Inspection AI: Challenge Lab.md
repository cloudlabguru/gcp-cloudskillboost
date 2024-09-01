## Detect Manufacturing Defects using Visual Inspection AI: Challenge Lab [SOLUTION]

### Task 1. Deploy the exported Cosmetic Inspection anomaly detection solution artifact
Fill with the given value, then run this script in CloudShell
```
export container_name=
```
Then run this script
```
export VISERVING_CPU_DOCKER_WITH_MODEL=${container_name}
export HTTP_PORT=8602
export LOCAL_METRIC_PORT=8603
docker pull ${VISERVING_CPU_DOCKER_WITH_MODEL}
docker run -v /secrets:/secrets --rm -d --name "container_name" \
--network="host" \
-p ${HTTP_PORT}:8602 \
-p ${LOCAL_METRIC_PORT}:8603 \
-t ${VISERVING_CPU_DOCKER_WITH_MODEL} \
--use_default_credentials=false \
--service_account_credentials_json=/secrets/assembly-usage-reporter.json
```

### Task 2. Prepare resources to serve the exported assembly inspection solution artifact
Run this script in CloudShell
```
gsutil cp gs://cloud-training/gsp895/prediction_script.py .
export PROJECT_ID=$(gcloud config get-value core/project)
gsutil mb gs://${PROJECT_ID}
gsutil -m cp gs://cloud-training/gsp897/cosmetic-test-data/*.png \
gs://${PROJECT_ID}/cosmetic-test-data/
gsutil cp gs://${PROJECT_ID}/cosmetic-test-data/IMG_07703.png .
```

### Task 3. Identify a defective product image
Fill with the given value, then run this script in CloudShell
```
export result_file=
```
Run this script in CloudShell
```
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3.11-venv -y 
python3 -m venv create myvenv
source myvenv/bin/activate
pip install absl-py  
pip install numpy 
pip install requests
python3 ./prediction_script.py --input_image_file=./IMG_07703.png  --port=8602 --output_result_file=${result_file}
```

### Task 4. Identify a non-defective product
Fill with the given value, then run this script in CloudShell
```
export result_file=
```
Run this script in CloudShell
```
export PROJECT_ID=$(gcloud config get-value core/project)
gsutil cp gs://${PROJECT_ID}/cosmetic-test-data/IMG_0769.png .
python3 ./prediction_script.py --input_image_file=./IMG_0769.png  --port=8602 --output_result_file=${result_file}
```

## Congratulations !! 
