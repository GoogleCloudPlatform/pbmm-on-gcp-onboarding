
cd $base_dir/6-org-policies

#get organization_id
export ORGANIZATION_ID=$(terraform -chdir="../0-bootstrap/" output -json common_config | jq '.org_id' --raw-output)
gcloud scc notifications describe "scc-notify" --organization=${ORGANIZATION_ID}

#Retrieve Service Account Email
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw organization_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./common.auto.tfvars

terraform init

# Run validation script(changed to single dot)
../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"

# Run Terraform plan and apply
#-var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS"
terraform plan -input=false -out org_policy.tfplan

#-var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS"
terraform apply org_policy.tfplan

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
pwd

