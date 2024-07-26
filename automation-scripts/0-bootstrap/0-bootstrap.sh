#!/bin/bash

set -e

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

