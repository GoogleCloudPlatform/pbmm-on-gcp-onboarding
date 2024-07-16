ls -la
rm -rf -- !(env.tar.gz)
ls -la
tar -zxf env.tar.gz
ls -la
rm -f env.tar.gz
ls -la
cd $base_dir/6-org-policies

cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

#get organization_id
export ORGANIZATION_ID=$(terraform -chdir="../0-bootstrap/" output -json common_config | jq '.org_id' --raw-output)
gcloud scc notifications describe "scc-notify" --organization=${ORGANIZATION_ID}

#Retrieve Service Account Email
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw organization_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

# sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./common.auto.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./common/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./development/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./nonproduction/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./production/terraform.tfvars
# cat ./common.auto.tfvars

cd ./common 

terraform init

# Run validation script(changed to single dot)
../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"

# Run Terraform plan and apply
#-var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS"
terraform plan -input=false -out org_policy.tfplan

#-var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS"
terraform apply org_policy.tfplan

cd ..

./tf-wrapper.sh init development
./tf-wrapper.sh plan development
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply development

./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply nonproduction

./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
tar -zcf env.tar.gz --exclude env.tar.gz . 
ls -la
pwd

