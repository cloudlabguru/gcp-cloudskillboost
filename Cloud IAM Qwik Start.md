## Cloud IAM: Qwik Start [SOLUTION]

Fill and run this following command in Cloud Shell
```
export USERNAME_2=
```

Copy this following command and run in Cloud Shell
```
gsutil mb -l us -b on gs://$DEVSHELL_PROJECT_ID

echo "HELLO WORLD" > sample.txt

gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID

gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/viewer

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/storage.objectViewer
```

## Congratulations !! 
