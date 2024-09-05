## Develop an App with Vertex AI Gemini 1.0 Pro [SOLUTION]

Fill this with the given value and run in CloudShell
```
REGION=
```
Run this script in CloudShell
```
PROJECT_ID=$(gcloud config get-value project)

mkdir ~/gemini-app
cd ~/gemini-app
python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate
```
### Task 1-13
Run this script in CloudShell
```
curl -LO raw.githubusercontent.com/cloudlabguru/gcp-cloudskillboost/main/Integrating%20Applications%20with%20Gemini%201.0%20Pro%20on%20Google%20Cloud/Develop%20an%20App%20with%20Vertex%20AI%20Gemini%201.0%20Pro/task.sh
sudo chmod +x task.sh
./task.sh
```
* Click web preview in the CloudShell menubar, and then click Preview on port 8080
* Test the app, click generate button in every tab
* Ctrl+C in CloudShell

### Task 14
Run this script in CloudShell
```
SERVICE_NAME='gemini-app-playground' 
AR_REPO='gemini-app-repo'

gcloud artifacts repositories create "$AR_REPO" --location="$REGION" --repository-format=Docker

gcloud auth configure-docker "$REGION-docker.pkg.dev"

gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME"

gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$PROJECT_ID \
  --set-env-vars=PROJECT_ID=$PROJECT_ID,REGION=$REGION
```
## Congratulations !! 
