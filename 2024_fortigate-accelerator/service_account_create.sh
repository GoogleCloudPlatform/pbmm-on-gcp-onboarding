# This script creates a custom role and a service account to be used by FortiGate instances

GCP_PROJECT_ID=$(gcloud config get-value project)

SRV_ACC=$(gcloud projects get-iam-policy $GCP_PROJECT_ID --flatten="bindings[].members" --filter="bindings.role:FortigateSdnReader" --format="value(bindings.members)")
echo $SRV_ACC | grep fortigatesdn && { echo "Account already exists"; exit; }

echo "Creating FortigateSdnReader role in project $GCP_PROJECT_ID..."
gcloud iam roles create FortigateSdnReader --project=$GCP_PROJECT_ID \
  --title="FortiGate SDN Connector Role (read-only)" \
  --permissions="compute.zones.list,compute.instances.list,container.clusters.list,container.nodes.list,container.pods.list,container.services.list"

echo "Creating new service account (FortiGate SDN Connector)..."
gcloud iam service-accounts create fortigatesdn-ro \
  --display-name="FortiGate SDN Connector"

echo "Granting fortigatesdn-ro service account access to project $GCP_PROJECT_ID..."
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:fortigatesdn-ro@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
  --role="projects/$GCP_PROJECT_ID/roles/FortigateSdnReader"

SRV_ACC=$(gcloud projects get-iam-policy $GCP_PROJECT_ID --flatten="bindings[].members" --filter="bindings.role:FortigateSdnReader" --format="value(bindings.members)")
echo $SRV_ACC | grep fortigatesdn && echo "Service account created succesfully" || echo "Something went wrong"
