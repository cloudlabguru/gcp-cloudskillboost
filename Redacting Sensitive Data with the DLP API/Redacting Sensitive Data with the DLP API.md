## Redacting Sensitive Data with the DLP API [SOLUTION]

Run this following command in Cloud Shell
```
gcloud services enable dlp.googleapis.com

export GCLOUD_PROJECT=$DEVSHELL_PROJECT_ID

git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples

cd nodejs-docs-samples/dlp

npm install @google-cloud/dlp
npm install yargs
npm install mime@2.5.2

node inspectString.js $GCLOUD_PROJECT "My email address is joe@example.com."

node inspectString.js $GCLOUD_PROJECT "My phone number is 555-555-5555."

node deidentifyWithMask.js $GCLOUD_PROJECT "My phone number is 555-555-5555."

curl -LO https://github.com/cloudlabguru/gcp-cloudskillboost/blob/main/Redacting%20Sensitive%20Data%20with%20the%20DLP%20API/dlp-input.png

node redactImage.js $GCLOUD_PROJECT ~/dlp-input.png "" EMAIL_ADDRESS ~/dlp-redacted.png
```

## Congratulations !! 
