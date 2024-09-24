## Explore Generative AI with the Vertex AI Gemini API: Challenge Lab [SOLUTION]

### Task 1. Generate text using Gemini
* Copy to [notepad](https://www.rapidtables.com/tools/notepad.html) and fill the ```LOCATION``` with given value <br/>
* Then run in Cloud Shell
```
pip3 install --upgrade --user google-cloud-aiplatform

PROJECT_ID=$(gcloud config get-value project)
LOCATION=""
API_ENDPOINT=${LOCATION}-aiplatform.googleapis.com
MODEL_ID="gemini-1.0-pro"

gcloud services enable aiplatform.googleapis.com

cat > request.json << 'EOF'
{
  "contents": [{ "role": "user", "parts": { "text": "Why is the sky blue?" }}],
  "generation_config": {"temperature": 0.5}
}
EOF

curl -X POST \
     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d @request.json \
     "https://${LOCATION}-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/publishers/google/models/gemini-1.0-pro:generateContent"
```

### Task 2-3
* Open Vertex AI Workbench > user managed notebook > open JupyterLab
* Run this in terminal
```
curl -LO raw.githubusercontent.com/cloudlabguru/gcp-cloudskillboost/refs/heads/main/Explore%20Generative%20AI%20with%20the%20Vertex%20AI%20Gemini%20API/gemini-explorer-challenge.ipynb
```
* Open the notebook file and fill the ```LOCATION``` <br/>
* Run all cells

## Congratulations !! 
