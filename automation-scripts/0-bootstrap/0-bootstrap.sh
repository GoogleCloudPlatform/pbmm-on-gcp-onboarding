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
