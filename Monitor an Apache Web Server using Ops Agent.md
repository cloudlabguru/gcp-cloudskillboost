## Monitor an Apache Web Server using Ops Agent [SOLUTION]

Copy this following command and run in Cloud Shell
```
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

gcloud compute instances create quickstart-vm --zone=$ZONE --machine-type=e2-small --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=quickstart-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20241009,mode=rw,size=10,type=pd-balanced

gcloud compute firewall-rules create allow-http-from-internet --target-tags=http-server --allow tcp:80 --source-ranges 0.0.0.0/0 --description="Allow HTTP from the internet"

gcloud compute firewall-rules create allow-https-from-internet --target-tags=https-server --allow tcp:443 --source-ranges 0.0.0.0/0 --description="Allow HTTPS from the internet"

cat > prepare_disk.sh <<'EOF_END'

sudo apt-get update && sudo apt-get install apache2 php7.0 -y

curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# Configures Ops Agent to collect telemetry from the app and restart Ops Agent.

set -e

# Create a back up of the existing file so existing configurations are not lost.
sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak

# Configure the Ops Agent.
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
metrics:
  receivers:
    apache:
      type: apache
  service:
    pipelines:
      apache:
        receivers:
          - apache
logging:
  receivers:
    apache_access:
      type: apache_access
    apache_error:
      type: apache_error
  service:
    pipelines:
      apache:
        receivers:
          - apache_access
          - apache_error
EOF

sudo service google-cloud-ops-agent restart
sleep 60

EOF_END

gcloud compute scp prepare_disk.sh quickstart-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh quickstart-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"

cat > email-channel.json <<EOF_END
{
  "type": "email",
  "displayName": "quickgcplab",
  "description": "Awesome",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_END

gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"

# Get the channel ID
email_channel_info=$(gcloud beta monitoring channels list)
email_channel_id=$(echo "$email_channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)

cat > vm-alert-policy.json <<EOF_END
{
  "displayName": "Apache traffic above threshold",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - workload/apache.traffic",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"workload.googleapis.com/apache.traffic\"",
        "aggregations": [
          {
            "alignmentPeriod": "60s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 4000
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "1800s",
    "notificationPrompts": [
      "OPENED"
    ]
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$email_channel_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_END

# Create the alert policy
gcloud alpha monitoring policies create --policy-from-file=vm-alert-policy.json
```

## Congratulations !! 
