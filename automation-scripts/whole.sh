#!/bin/bash

set -xe

# Set base directory
base_dir=$(pwd)

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=sa-gcp-partners-test@sa-test-gcp.iam.gserviceaccount.com
GOOGLE_APPLICATION_CREDENTIALS=$1
cd "$base_dir/7-fortigate/shared"
gcloud secrets versions access latest --secret=license1 --project=sa-test-gcp > license1.lic
gcloud secrets versions access latest --secret=license2 --project=sa-test-gcp > license2.lic
echo "Listing Fortigate Files"
ls "$base_dir/7-fortigate/shared"

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

# sed -i'' -e "s/user_project_override = true/credentials = file(var.gcp_credentials_file)\n\tuser_project_override = true/" ./provider.tf

# content="variable \"gcp_credentials_file\" {
#   description = \"Path to the Google Cloud Platform service account key file\"
#   type        = string
# }"

# echo "$content" >> variables.tf 

cat ./provider.tf
cat ./variables.tf
cat ./terraform.tfvars
cat ./terraform.tf


# Initialize Terraform
terraform init
set +e
# Run validation script(changed to single dot)
../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"

# Run Terraform plan and apply
#-var="gcp_credentials_file=$GOOGLE_APPLICATION_CREDENTIALS"
terraform plan -input=false -out bootstrap.tfplan

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


set -xe

# Set base directory
base_dir=$(pwd)
# Defin variables

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=sa-gcp-partners-test@sa-test-gcp.iam.gserviceaccount.com

cd $base_dir/1-org
ls ./envs/shared/
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

set +e
#Update .tfvars File
if [ ! -z "${ACCESS_CONTEXT_MANAGER_ID}" ]; then
  sed -i'' -e "s=//create_access_context_manager_access_policy=create_access_context_manager_access_policy=" ./envs/shared/terraform.tfvars;
fi
set -xe
#Retrieve Backend Bucket Name
export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

# Update .tfvars File
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./envs/shared/terraform.tfvars

#Retrieve Service Account Email
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw organization_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

export seed_project_id=$(terraform -chdir="../0-bootstrap/" output -raw seed_project_id)
echo "seed_project_id = ${seed_project_id}"

sed -i'' -e "s/\"projects\/fortigcp-project-001\"/\"projects\/fortigcp-project-001\",\"projects\/${seed_project_id}\"/" ./envs/shared/terraform.tfvars

sed -i'' -e "s/DOMAIN/${DOMAIN}/" ./envs/shared/terraform.tfvars
cat ./envs/shared/terraform.tfvars

./tf-wrapper.sh init production
./tf-wrapper.sh plan production
set +e
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production
set +e

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..


pwd

set -xe



# Set base directory 
base_dir=$(pwd)

cd $base_dir/2-environments
ls -la
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
ls -la 
cat ./terraform.tfvars
cat ./envs/development/terraform.tfvars
cat ./envs/nonproduction/terraform.tfvars
cat ./envs/production/terraform.tfvars

#Terraform init,plan,validate,apply for development env
./tf-wrapper.sh init development
./tf-wrapper.sh plan development
set +e
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply development

#Terraform init,plan,validate,apply for nonproduction env
./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
set +e
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply nonproduction

#Terraform init,plan,validate,apply for production env
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
set +e
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply production

./tf-wrapper.sh init management
./tf-wrapper.sh plan management
set +e
./tf-wrapper.sh validate management $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply management

./tf-wrapper.sh init identity
./tf-wrapper.sh plan identity
set +e
./tf-wrapper.sh validate identity $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply identity
set +e

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..

pwd

set -xe


# Set base directory 
base_dir=$(pwd)

cd $base_dir/3-networks-hub-and-spoke
ls -la
#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

ls -la ./envs/development/
ls -la ./envs/nonproduction/
ls -la ./envs/production/

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

sed -i'' -e "s/DOMAIN/${DOMAIN}/" ./common.auto.tfvars
sed -i'' -e "s/PERIMETER_USER/\"$PERIMETER_USER\"/" ./common.auto.tfvars


#setting google impersonate service account
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw networks_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

cat ./access_context.auto.tfvars
cat ./common.auto.tfvars
cat ./envs/development/access_context.auto.tfvars
cat ./envs/development/common.auto.tfvars
cat ./envs/nonproduction/access_context.auto.tfvars
cat ./envs/nonproduction/common.auto.tfvars
cat ./envs/production/access_context.auto.tfvars
cat ./envs/production/common.auto.tfvars

./tf-wrapper.sh init shared
./tf-wrapper.sh plan shared
set +e
./tf-wrapper.sh validate shared $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply shared

# While loop to be added for contionus apply
./tf-wrapper.sh init production 
./tf-wrapper.sh plan production 
set +e
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production 


./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
set +e
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply nonproduction


./tf-wrapper.sh init development
./tf-wrapper.sh plan development
set +e
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply development



./tf-wrapper.sh init management
./tf-wrapper.sh plan management
set +e
./tf-wrapper.sh validate management $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply management

./tf-wrapper.sh init identity
./tf-wrapper.sh plan identity
set +e
./tf-wrapper.sh validate identity $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply identity
set +e

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..

pwd


sleep 120s
set -xe


# Set base directory 
base_dir=$(pwd)

cd $base_dir/4-projects

ls -la
#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

ls -la ./business_units/development/
ls -la ./business_units/nonproduction/
ls -la ./business_units/production/

#Retrieve Terraform Remote State Bucket Name
export remote_state_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${remote_state_bucket}"

#Update common.auto.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${remote_state_bucket}/" ./common.auto.tfvars

#Setting the Variable
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw projects_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}



#Terraform init,plan,validate,apply for development env
# sleep 120s
cat ./common.auto.tfvars
cat ./business_units/development/common.auto.tfvars
cat ./business_units/development/development.auto.tfvars
cat ./business_units/nonproduction/common.auto.tfvars
cat ./business_units/nonproduction/nonproduction.auto.tfvars
cat ./business_units/production/common.auto.tfvars
cat ./business_units/production/production.auto.tfvars

./tf-wrapper.sh init shared
./tf-wrapper.sh plan shared
set +e
./tf-wrapper.sh validate shared $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply shared

# Run all tf-wrapper commands
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
set +e
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply production

#Terraform init,plan,validate,apply for nonproduction env
./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
set +e
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply nonproduction


./tf-wrapper.sh init development
./tf-wrapper.sh plan development
set +e
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply development


./tf-wrapper.sh init management
./tf-wrapper.sh plan management
set +e
./tf-wrapper.sh validate management $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply management

./tf-wrapper.sh init identity
./tf-wrapper.sh plan identity
set +e
./tf-wrapper.sh validate identity $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
set -xe
./tf-wrapper.sh apply identity
set +e


unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..

pwd

set -xe



base_dir=$(pwd)

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

sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./common/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./development/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./nonproduction/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./production/terraform.tfvars
# cat ./common.auto.tfvars

cd ./common 
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply

terraform plan -input=false -out org_policy_common.tfplan

terraform apply org_policy_common.tfplan

cd ..
pwd
cd ./development
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply

terraform plan -input=false -out org_policy_development.tfplan

terraform apply org_policy_development.tfplan

cd ..
pwd
cd ./nonproduction
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply
terraform plan -input=false -out org_policy_nonproduction.tfplan

terraform apply org_policy_nonproduction.tfplan

cd ..
pwd
cd ./production
pwd
terraform init
set +e
# Run validation script(changed to single dot)
../../scripts/validate-requirements.sh -o "$ORG_ID" -b "$BILLING_ID" -u "$SUPER_ADMIN_EMAIL"
set -xe
# Run Terraform plan and apply
terraform plan -input=false -out org_policy_production.tfplan

terraform apply org_policy_production.tfplan

cd ..
pwd
set +e
unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
pwd

pwd

set -xe
base_dir=$(pwd)
cd $base_dir/7-fortigate

ls

ls ./shared

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw organization_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}
set +e
chmod 755 ./prepare.sh
./prepare.sh clean

pwd
cd ../0-bootstrap/ && terraform output
cd $base_dir/7-fortigate
file ./shared/*.lic

sh -x ./prepare.sh prep 
pwd

cd ./shared

ls
terraform init

# Run Terraform plan and apply
terraform plan -input=false -out fortigate.tfplan
set -xe
terraform apply fortigate.tfplan

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT
set +e

cd ..

ls -la
pwd
