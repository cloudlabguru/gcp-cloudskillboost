## Get Started with Cloud Storage: Challenge Lab [SOLUTION]

Fill and run this following command in Cloud Shell
```
export BUCKET_1=
```
```
export BUCKET_2=
```
```
export BUCKET_3=
```

First you need to find under ```Challenge Scenario``` which form is yours

If ```form-1```, copy this following command and run in Cloud Shell
```
export BUCKET="$(gcloud config get-value project)"		

gsutil mb -p $BUCKET gs://$BUCKET_1

gsutil retention set 30s gs://$BUCKET_2

echo "test" > sample.txt

gsutil cp sample.txt gs://$BUCKET_3/
```

If ```form-2```, copy this following command and run in Cloud Shell
```
gsutil mb -c nearline gs://$BUCKET_1

gcloud alpha storage buckets update gs://$BUCKET_2 --no-uniform-bucket-level-access

gsutil acl ch -u $USER_EMAIL:OWNER gs://$BUCKET_2

gsutil rm gs://$BUCKET_2/sample.txt

echo "test" > sample.txt

gsutil cp sample.txt gs://$BUCKET_2

gsutil acl ch -u allUsers:R gs://$BUCKET_2/sample.txt

gcloud storage buckets update gs://$BUCKET_3 --update-labels=key=value
```

If ```form-3```, copy this following command and run in Cloud Shell
```
gsutil mb -c coldline gs://$BUCKET_1

echo "This is an example of editing the file content for cloud storage object" | gsutil cp - gs://$BUCKET_2/sample.txt

gsutil defstorageclass set ARCHIVE gs://$BUCKET_3
```

## Congratulations !! 
