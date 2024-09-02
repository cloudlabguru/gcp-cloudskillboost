cd ~/gemini-app
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

PROJECT_ID=$(gcloud config get-value project)
REGION=set at lab start
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

SERVICE_NAME='gemini-app-playground' # Name of your Cloud Run service.
AR_REPO='gemini-app-repo'            # Name of your repository in Artifact Registry that stores your application container image.
echo "SERVICE_NAME=${SERVICE_NAME}"
echo "AR_REPO=${AR_REPO}"

gcloud artifacts repositories create "$AR_REPO" --location="$REGION" --repository-format=Docker
gcloud auth configure-docker "$REGION-docker.pkg.dev"

cat > ~/gemini-app/Dockerfile <<EOF
FROM python:3.8

EXPOSE 8080
WORKDIR /app

COPY . ./

RUN pip install -r requirements.txt

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]

EOF

gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME"

gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$PROJECT_ID \
  --set-env-vars=PROJECT_ID=$PROJECT_ID,REGION=$REGION
