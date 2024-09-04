## Develop an App with Vertex AI Gemini 1.0 Pro [SOLUTION]

Fill this with the given value and run in CloudShell
```
REGION=
```
Run this script in CloudShell
```
PROJECT_ID=$(gcloud config get-value project)
SERVICE_NAME='gemini-app-playground' 
AR_REPO='gemini-app-repo'

mkdir ~/gemini-app
cd ~/gemini-app
python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate
```
### Task 1-14
Run this script in CloudShell
```
curl -LO raw.githubusercontent.com/cloudlabguru/gcp-cloudskillboost/main/Integrating%20Applications%20with%20Gemini%201.0%20Pro%20on%20Google%20Cloud/Develop%20an%20App%20with%20Vertex%20AI%20Gemini%201.0%20Pro/task.sh
sudo chmod +x task.sh
./task.sh
```
* Click web preview in the CloudShell menubar, and then click Preview on port 8080
* Test the app, click generate button in every tab
* Ctrl+C in CloudShell

## Congratulations !! 
