#!/bin/bash

# set -e

# Set base directory
base_dir=$(pwd)

# Define variables
export SUPER_ADMIN_EMAIL=$SUPER_ADMIN_EMAIL
export REGION=$REGION
export ORG_ID=$ORG_ID
export ROOT_FOLDER_ID=$ROOT_FOLDER_ID
export BILLING_ID=$BILLING_ID
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=sa-gcp-partners-test@sa-test-gcp.iam.gserviceaccount.com
GOOGLE_APPLICATION_CREDENTIALS=$1

echo "Base Directory:" $base_dir
# Change directory
cd "$base_dir/0-bootstrap"

echo "here" $GOOGLE_IMPERSONATE_SERVICE_ACCOUNT
./prep.sh tf_local

ls -ltr


#Replace Folder Root Value
sed -i'' -e "s/ORG_ID_REPLACE_ME/${ORG_ID}/" ./terraform.tfvars

sed -i'' -e "s/BILLING_ID_REPLACE_ME/${BILLING_ID}/" ./terraform.tfvars

sed -i'' -e "s/PARENT_FOLDER_REPLACE_ME/${ROOT_FOLDER_ID}/" ./terraform.tfvars

#Replace Region Value
sed -i'' -e "s/DEFAULT_REGION_REPLACE_ME/${REGION}/" ./terraform.tfvars

sed -i'' -e "s/user_project_override = true/credentials = file(var.gcp_credentials_file)\n\tuser_project_override = true/" ./provider.tf

content="variable \"gcp_credentials_file\" {
  description = \"Path to the Google Cloud Platform service account key file\"
  type        = string
}"

echo "$content" >> variables.tf 

cat ./provider.tf
cat ./variables.tf
cat ./terraform.tfvars
cat ./terraform.tf


# Initialize Terraform
terraform init

# Run validation script(changed to single dot)
../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"

# Run Terraform plan and apply
#-var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS"
terraform plan -var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS" -input=false -out bootstrap.tfplan

#-var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS"
terraform apply bootstrap.tfplan

# Get service account and bucket outputs
export network_step_sa=$(terraform output -raw networks_step_terraform_service_account_email)
export projects_step_sa=$(terraform output -raw projects_step_terraform_service_account_email)
export projects_gcs_bucket_tfstate=$(terraform output -raw projects_gcs_bucket_tfstate)

echo "network step service account = ${network_step_sa}"
echo "projects step service account = ${projects_step_sa}"
echo "projects gcs bucket tfstate = ${projects_gcs_bucket_tfstate}"

# Get backend bucket outputs
export backend_bucket=$(terraform output -raw gcs_bucket_tfstate)
echo "backend_bucket = ${backend_bucket}"
export backend_bucket_projects=$(terraform output -raw projects_gcs_bucket_tfstate)
echo "backend_bucket_projects = ${backend_bucket_projects}"


# Rename backend.tf File:
mv backend.tf_to_rename_after_apply backend.tf

# Update backend.tf files (replace placeholders)
cd ..
for i in `find . -name 'backend.tf'`; do sed -i'' -e "s/UPDATE_ME/${backend_bucket}/" $i; done
for i in `find . -name 'backend.tf'`; do sed -i'' -e "s/UPDATE_PROJECTS_BACKEND/${backend_bucket_projects}/" $i; done

cd 0-bootstrap

# Initialize Terraform again
terraform init -force-copy

export CLOUD_BUILD_PROJECT_ID=$(terraform output -raw cicd_project_id)
echo $CLOUD_BUILD_PROJECT_ID

cd ..
pwd


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
pwd

sleep 300s

# Set base directory 
base_dir=$(pwd)

cd $base_dir/2-environments

# ln -s terraform.mod.tfvars terraform.tfvars

#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh


# Retrieve Actual Bucket Name
export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./terraform.tfvars

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw environment_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

#Terraform init,plan,validate,apply for development env
./tf-wrapper.sh init development
./tf-wrapper.sh plan development
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply development

#Terraform init,plan,validate,apply for nonproduction env
./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply nonproduction

#Terraform init,plan,validate,apply for production env
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production


unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
pwd

sleep 300s

# Set base directory 
base_dir=$(pwd)

cd $base_dir/3-networks-hub-and-spoke

#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

#get organization_id
export ORGANIZATION_ID=$(terraform -chdir="../0-bootstrap/" output -json common_config | jq '.org_id' --raw-output)

# Retrieve AACCESS_CONTEXT_MANAGER_ID Policy ID
export ACCESS_CONTEXT_MANAGER_ID=$(gcloud access-context-manager policies list --organization ${ORGANIZATION_ID} --format="value(name)")
echo "access_context_manager_policy_id = ${ACCESS_CONTEXT_MANAGER_ID}"

#update access_context.auto.tfvars
sed -i'' -e "s/ACCESS_CONTEXT_MANAGER_ID/${ACCESS_CONTEXT_MANAGER_ID}/" ./access_context.auto.tfvars

# Retrieve Terraform Remote State Bucket Name:
export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

#Update common.auto.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./common.auto.tfvars

#setting google impersonate service account
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw networks_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}


./tf-wrapper.sh init shared
./tf-wrapper.sh plan shared
./tf-wrapper.sh validate shared $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply shared

# While loop to be added for contionus apply
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production

MAX_RETRIES=3  # Adjust as needed
attempts=0
while [[ $attempts -lt $MAX_RETRIES ]]; do
  # Run all tf-wrapper commands
  ./tf-wrapper.sh init nonproduction
  ./tf-wrapper.sh plan nonproduction
  ./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
  ./tf-wrapper.sh apply nonproduction

  # Check if any command failed (check exit code of last command)
  if [[ $? -ne 0 ]]; then
    echo "Error: Some tf-wrapper commands failed. Retrying..."
    ((attempts++))
  else
    echo "All tf-wrapper nonproduction commands applied successfully!"
    break  # Exit the loop on success
  fi
done

./tf-wrapper.sh init development
./tf-wrapper.sh plan development
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply development

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
pwd

sleep 300s

# Set base directory 
base_dir=$(pwd)

cd $base_dir/4-projects


#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh


#Retrieve Terraform Remote State Bucket Name
export remote_state_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${remote_state_bucket}"

#Update common.auto.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${remote_state_bucket}/" ./common.auto.tfvars

#Setting the Variable
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw projects_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

./tf-wrapper.sh init shared
./tf-wrapper.sh plan shared
./tf-wrapper.sh validate shared $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply shared

#Terraform init,plan,validate,apply for development env


# Run all tf-wrapper commands
./tf-wrapper.sh init development
./tf-wrapper.sh plan development
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply development



#Terraform init,plan,validate,apply for nonproduction env
./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply nonproduction


# Run all tf-wrapper commands
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
pwd





