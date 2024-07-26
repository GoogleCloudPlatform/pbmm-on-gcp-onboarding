#!/bin/bash

# Set base directory
base_dir=$(pwd)
# Defin variables
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=sa-gcp-partners-test@sa-test-gcp.iam.gserviceaccount.com

cd $base_dir/1-org

#copy the wrapper script
cp ../build/tf-wrapper.sh .

#set read,write,execute permissions
chmod 755 ./tf-wrapper.sh

ls -ltr

#get organization_id
export ORGANIZATION_ID=$(terraform -chdir="../0-bootstrap/" output -json common_config | jq '.org_id' --raw-output)
gcloud scc notifications describe "scc-notify" --organization=${ORGANIZATION_ID}

# Retrieve AACCESS_CONTEXT_MANAGER_ID Policy ID
export ACCESS_CONTEXT_MANAGER_ID=$(gcloud access-context-manager policies list --organization ${ORGANIZATION_ID} --format="value(name)")
echo "access_context_manager_policy_id = ${ACCESS_CONTEXT_MANAGER_ID}"

#Update .tfvars File
if [ ! -z "${ACCESS_CONTEXT_MANAGER_ID}" ]; then
  sed -i'' -e "s=//create_access_context_manager_access_policy=create_access_context_manager_access_policy=" ./envs/shared/terraform.tfvars;
fi

#Retrieve Backend Bucket Name
export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

# Update .tfvars File
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./envs/shared/terraform.tfvars

#Retrieve Service Account Email
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw organization_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
tar -zcf env.tar.gz --exclude env.tar.gz . 
ls -la

pwd
