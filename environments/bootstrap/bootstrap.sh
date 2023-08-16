#!/bin/bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


###############################################################################
#                        Terraform top-level resources                        #
###############################################################################



set -e
export PLAN_FILE="launchpad.`date +%Y-%m-%d.%H%m`.plan"
export STATE_FILE="default.tfstate"

##############################################
# Run all steps in a row
# Globals:
#  PlAN_FILE
#  STATE_FILE
# Arguments:
#  None
##############################################
function run () {
 auth
 apply_roles
 tf_apply
 upload_statefile
 create_backends
 create_csr
} 

##############################################
# Authenticates gcloud
# Globals: 
#  None
# Arguments: 
#  None
##############################################
function auth () {  
if ! gcloud config list --format json > /dev/null; then
 "ERROR - No gcloud config detected please run gcloud init or gcloud auth login"
 exit 1
elif gcloud config list --format json > /dev/null; then
  USER=$(gcloud config list --format json|jq .core.account | sed 's/"//g')
  DOMAIN=$(echo $USER | sed 's/"//g' | cut -f2 -d@)
fi
  echo "User: ${USER}"
  echo "Domain: ${DOMAIN}"
  read -p "Is this the user and domain of the organization you want to deploy to? (y/n) `echo $'\n> '` " -r

if [[ $REPLY =~ ^[Nn]$ ]]; then
  echo "Login first with: gcloud auth login"
  gcloud auth application-default login
  echo "Specify the target organization domain"
  read DOMAIN 
fi
}

##############################################
# Applies Roles based on domain and user email
# Globals: 
#  ORGID
#  ROLES
# Arguments: 
#  None
##############################################
function apply_roles () {
if [[ -z "$USER" ]]; then
  auth
fi
# Set Vars for Permissions application
PROJECT_ID="$(gcloud config get-value project)"
#ORGID="$(gcloud projects get-ancestors $PROJECT_ID | grep organization | cut -f1 -d' ')"
ORGID=$(gcloud organizations list --format="get(name)" --filter=displayName=$DOMAIN)
ORGID=${ORGID#"organizations/"}
ROLES=("roles/billing.projectManager" "roles/orgpolicy.policyAdmin" "roles/resourcemanager.folderCreator" "roles/resourcemanager.organizationViewer" "roles/resourcemanager.projectCreator" "roles/billing.projectManager" "roles/billing.viewer" "roles/cloudbuild.workerPoolOwner")

# Loop through each Role in Roles and apply to Organization node. 
echo "INFO - Applying roles to Organization Node"
for i in "${ROLES[@]}" ; do
  gcloud organizations add-iam-policy-binding $ORGID  --member=user:$USER --role=$i --quiet > /dev/null 1>&1
done
}

##############################################
# Applies terraform code based on plan file
# Globals: 
#  STATE_FILE
#  PLAN_FILE
# Arguments: 
#  None
##############################################
function tf_apply () {
echo "INFO - Running a plan to ensure the configuration file is correct"
terraform init
#terraform plan -var-file=../../config/organization-config.tfvars -var-file=../../config/bootstrap.tfvars -state=${STATE_FILE} -out=${PLAN_FILE}
terraform plan -state=${STATE_FILE} -out=${PLAN_FILE}
{
  echo "Please confirm that you have reviewed the plan and wish to apply it. Type 'yes' to proceed";
  read ;
  echo "";
  if [ "${REPLY}" != "yes" ] ; then
    echo "INFO - User did not approve plan. Exiting"
    exit 0
  fi
}

# Apply
echo "INFO - Applying Terraform plan"
terraform apply -parallelism=30 -state=${STATE_FILE} ${PLAN_FILE}
}

##############################################
# Collects state information and uploads statefile to the new buckets
# Globals: 
#  STATE_FILE
# Arguments: 
#  None
##############################################
function upload_statefile () {
COMMON_BUCKET=$(terraform output -state=${STATE_FILE} -json |jq -r '.tfstate_bucket_names.value.common' )
NONPROD_BUCKET=$(terraform output -state=${STATE_FILE} -json |jq -r '.tfstate_bucket_names.value.nonprod')
PROD_BUCKET=$(terraform output -state=${STATE_FILE} -json |jq -r '.tfstate_bucket_names.value.prod')
PROJECT_ID=$(terraform output  -state=${STATE_FILE} -json |jq -r '.project_id.value')

STATE_TO_UPLOAD=`find . -name ${STATE_FILE}`
STATE_FILE_PATH="environments/bootstrap/${STATE_FILE}"
if [ "${STATE_TO_UPLOAD}" != "" ]; then
  # Upload file to storage
  # Container - tfstate (hard code and must align to core_infrastructure/bootstrap/terraform.tfvars)
  echo "INFO - Uploading ${STATE_TO_UPLOAD} to ${COMMON_BUCKET}/${STATE_FILE_PATH} ${PROJECT_ID}"
  gsutil cp ${STATE_TO_UPLOAD} gs://${COMMON_BUCKET}/${STATE_FILE_PATH}
fi
}

#####################################################################
# backend
# Writes a backend.tf file to the environment after bootstrap 
# inputs:
# $1: relative path from bootstrap
# $2: bucket name parsed from state file
# $3: 
# $4: prefix corresponding to bootstrap state
# $5: prefix correspond to common state
# outputs: 
#  $1/backend.tf file written
#####################################################################
function backend () {
#TF_SVC_ACCT=$(terraform output -state=${STATE_FILE} -json |jq -r '.service_account_email.value')
TF_SVC_ACCT=$(jq -r .outputs.service_account_email.value ${STATE_FILE})
cat << EOF > ${1}/backend.tf

terraform {
  backend "gcs" {
    bucket = "${2}"
    prefix = "${3}"
  }
}

data "terraform_remote_state" "bootstrap" {
    backend = "gcs"
    config = {
      bucket = "${6}"
      prefix = "${4}"
    }  
}

data "terraform_remote_state" "common" {
    backend = "gcs"
    config = {
      bucket = "${6}"
      prefix = "${5}"
    }
}

EOF
cat << EOF > ${1}/provider.tf
provider "google" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google-beta" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
}
provider "google-beta" {
  access_token = data.google_service_account_access_token.default.access_token

}
provider "null" {

}
data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = "${TF_SVC_ACCT}"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1800s"
}
EOF
}

function provider () {
TF_SVC_ACCT=$(jq -r .outputs.service_account_email.value ${STATE_FILE})
cat << EOF > ${1}/provider.tf
provider "google" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google-beta" {
  alias = "impersonate"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
}
provider "google-beta" {
  access_token = data.google_service_account_access_token.default.access_token

}
provider "null" {

}
data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = "${TF_SVC_ACCT}"
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1800s"
}

EOF
}
##############################################
# creates backends
# Globals: 
#  STATE_FILE
# Arguments: 
#  None
##############################################
function create_backends () {
if [ -f "$STATE_FILE" ]; then
    echo "Terraform $STATE_FILE exists."
COMMON_BUCKET=$(jq -r '.outputs.tfstate_bucket_names.value.common' ${STATE_FILE})
NONPROD_BUCKET=$(jq -r '.outputs.tfstate_bucket_names.value.nonprod' ${STATE_FILE})
PROD_BUCKET=$(jq -r '.outputs.tfstate_bucket_names.value.prod' ${STATE_FILE})
TF_SVC_ACCT=$(jq -r '.outputs.service_account_email.value' ${STATE_FILE})
BOOTSTRAP_STATE_PREFIX="environments/bootstrap"
COMMON_STATE_PREFIX="environments/common"
NONPROD_STATE_PREFIX="environments/nonprod"
PROD_STATE_PREFIX="environments/prod"

echo "INFO - Create bootstrap backend"
cat << EOF > ./backend.tf
terraform {
  backend "gcs" {
    bucket = "${COMMON_BUCKET}"
    prefix = "${BOOTSTRAP_STATE_PREFIX}"
  }
}
EOF
echo "INFO - Create common backend"
cat << EOF > ../common/backend.tf
terraform {
  backend "gcs" {
    bucket = "${COMMON_BUCKET}"
    prefix = "${COMMON_STATE_PREFIX}"
  }
}
data "terraform_remote_state" "bootstrap" {
    backend = "gcs"
    config = {
      bucket = "${COMMON_BUCKET}"
      prefix = "${BOOTSTRAP_STATE_PREFIX}"
    }  
}
EOF

# create downstream environment versions
# backend PATH STATE_BUCKET ENV_PREFIX BOOTSTRAP_PREFIX COMMON_PREFIX
echo "INFO - Create bootstrap provider"
provider "."
echo "INFO - Create common provider"
provider "../common"
echo "INFO - Create nonprod backend and provider"
backend "../nonprod" $NONPROD_BUCKET $NONPROD_STATE_PREFIX $BOOTSTRAP_STATE_PREFIX $COMMON_STATE_PREFIX $COMMON_BUCKET
provider "../nonprod"
echo "INFO - Create prod backend and provider"
backend "../prod" $PROD_BUCKET $PROD_STATE_PREFIX $BOOTSTRAP_STATE_PREFIX $COMMON_STATE_PREFIX $COMMON_BUCKET
provider "../prod"

else 
    echo "$STATE_FILE does not exist. Apply terraform first to generate local statefile. "
    exit 1
fi 
}

##############################################
# Creates git mirror and pushes to Cloud Source Repository
# Globals: 
#  STATE_FILE
# Arguments: 
#  None
##############################################
function create_csr () {  
  echo "INFO - Committing code to CSR"
  (cd ../../; yes | rm -r .git)
  CLOUD_SOURCE_REPO=$(jq -r '.outputs.csr_name.value' ${STATE_FILE}) || echo "ERROR - Issue finding repo value in statefile"
  PROJECT_ID=$(jq -r '.outputs.project_id.value' ${STATE_FILE}) || echo "ERROR - Issue finding project_id value in statefile"
  echo "Specify your git config email"
  read GIT_CONFIG_EMAIL
  echo "Specify your git config name"
  read GIT_CONFIG_NAME
  (cd ../../; env -i git init)
  (cd ../../; env -i git checkout -b main)
  (cd ../../; git config user.name $GIT_CONFIG_NAME)
  (cd ../../; git config credential.helper gcloud.sh)
  (cd ../../; git config user.email $GIT_CONFIG_EMAIL)
  (cd ../../; env -i git add -A && git commit -m "bootstrap run `date +%Y-%m-%d.%H%m`" || echo "ERROR - Error committing changes to git" )
  echo "INFO - Check if CSR is already a git remote"
  if git config remote.csr.url > /dev/null; then
    echo "INFO - Check if CSR is malformed"
    URL=$(git config remote.csr.url)
    MALURL="/p//r/"
    if [[ $URL =~ .*$MALURL.* ]]; then
      echo "WARN - CSR was malformed: ${URL}"
      (cd ../../; env -i git remote remove csr)
      (cd ../../; env -i git remote add csr "https://source.developers.google.com/p/${PROJECT_ID}/r/${CLOUD_SOURCE_REPO}")
      echo "INFO - CSR was updated $(env -i git config remote.csr.url)"
    fi
    NEWURL=$(env -i git config remote.csr.url)
    read -p "INFO - Is this URL correct? ${NEWURL} (y/n) `echo $'\n> '`" -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "INFO - Pushing code to CSR"
      (cd ../../; env -i git push -f --all csr)
      echo "INFO - Code pushed to CSR"
    else 
      (cd ../../; env -i git remote remove csr)
      read -p "INFO - Enter the url: https://source.developers.google.com/p/PROJECT_ID/r/CLOUD_SOURCE_REPO `echo $'\n> '`" 
      (cd ../../; env -i git remote add csr $REPLY)
      echo "INFO - Pushing code to CSR"
      (cd ../../; env -i git push -f --all csr)
      echo "INFO - Code pushed to CSR"
    fi

  elif ! git config remote.csr.url > /dev/null; then
    echo "INFO - CSR is not a remote, adding it"
    (cd ../../; env -i git remote add csr "https://source.developers.google.com/p/${PROJECT_ID}/r/${CLOUD_SOURCE_REPO}")
    echo "INFO - Pushing code to CSR"
    (cd ../../; env -i git push -f --all csr)
    echo "INFO - Code pushed to CSR"
  fi
}

##############################################
# Pushes code and moves Build Triggers to another Git repository
# Globals: 
#  STATE_FILE
# Arguments: 
#  None
##############################################
function use_another_repo () {
  terraform init
  terraform refresh
  local project_id=$(terraform state pull | jq -r '.outputs.project_id.value')
  local current_cloud_source_repo_name=$(terraform state pull | jq -r '.outputs.csr_name.value')
  echo "INFO - PROJECT_ID: $project_id"
  echo "INFO - Build Triggers currently connected to the following CSR Repository: $current_cloud_source_repo_name"
  echo "INFO - We will ask you for the target Git repository name you would like to use. It can be a CSR repository, or an external repository."
  echo "INFO - If it is an external repository, please go to https://source.cloud.google.com/repo/connect to connect it to CSR before proceeding."
  read -n 1 -p "INFO - After the repository is in CSR, press ANY key to continue...$(echo $'\n')"
  read -p "INFO - Enter the name of the target CSR Repository: $(echo $'\n> ')"
  local target_cloud_source_repo_name=$(echo "$REPLY" | xargs)
  # Prepare to rename landing_zone_bootstrap.google_sourcerepo_repository.csr and move its Build Triggers to the target repository
  terraform state rm module.landing_zone_bootstrap.google_sourcerepo_repository.csr || true # Because the state could be already removed
  terraform import module.landing_zone_bootstrap.google_sourcerepo_repository.csr "projects/$project_id/repos/$target_cloud_source_repo_name"
  # Replacing the cloud_source_repo_name in bootstrap.auto.tfvars: terraform doesn't support using -var for nested variables yet
  if [[ $OSTYPE == 'darwin'* ]]
  then
    sed -i '' "s/cloud_source_repo_name.*/cloud_source_repo_name      = \"$target_cloud_source_repo_name\"/g" ./bootstrap.auto.tfvars
  else
    sed -i "s/cloud_source_repo_name.*/cloud_source_repo_name      = \"$target_cloud_source_repo_name\"/g" ./bootstrap.auto.tfvars
  fi
  terraform validate
  terraform apply --auto-approve || { echo "ERROR - In case of transient '443: connect: cannot assign requested address' error, please try running this script again."; exit 1; }
  echo "INFO - We will ask you for the target Git repository url"
  echo "INFO - For CSR, the url format is https://source.developers.google.com/p/PROJECT_ID/r/CLOUD_SOURCE_REPO"
  echo "INFO - For Github, make sure you are authenticated to push to the remote url (for information on remote urls, see https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#about-remote-repositories). To use a SSH urls, for example, you can refer to https://docs.github.com/en/authentication/connecting-to-github-with-ssh. To use a HTTPS urls, you can refer to https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token for more information."
  # Getting and validating the Target Repository URL
  echo "INFO - Validating that the target repository exists and that you have permission to push to it..."
  local is_valid_target_repo_url=false
  while ! $is_valid_target_repo_url; do
    read -p "INFO - Enter the target repository url: $(echo $'\n> ')"
    local target_repo_url=$(echo "$REPLY" | xargs)
    env -i git ls-remote "$target_repo_url" && is_valid_target_repo_url=true || echo "Invalid target repository url $target_repo_url. Please input a valid url."
  done
  echo "INFO - target repository url $is_valid_target_repo_url validated!"
  # Commit code changes
  env -i git add -A && git commit -m "bootstrap use_another_repo $(date +%Y-%m-%d.%H%m)" || { echo "ERROR - Error committing changes to git"; exit 1; }
  echo "INFO - Replacing csr remote..."
  env -i git remote remove csr
  env -i git remote add csr "$target_repo_url"
  echo "INFO - Pushing code to $target_repo_url"
  env -i git push -f --all csr
  echo "INFO - Code pushed to $target_repo_url."
  echo "INFO - Done. You can check the Build Triggers at https://console.cloud.google.com/cloud-build/triggers?project=$project_id"
}

function repair_symlinks () {
  echo "INFO - repairing symlinks"
  cd ../../modules/naming-standard/modules/gcp
  cd ./compute_address_external_ip && ln -snf ../../common/module/common.tf common.tf 
  cd ../managed_disk_data && ln -snf ../../common/module/common_bypass_prefix.tf common_bypass_prefix.tf
  cd ../vpn_tunnel_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../cloud_scheduler_job && ln -snf ../../common/module/common.tf common.tf 
  cd ../container_registry_image && ln -snf ../../common/module/common.tf common.tf 
  cd ../route && ln -snf ../../common/module/common_bypass_prefix.tf common_bypass_prefix.tf
  cd ../region_backend_service && ln -snf ../../common/module/common.tf common.tf 
  cd ../cloudbuild_trigger && ln -snf ../../common/module/common.tf common.tf 
  cd ../virtual_machine && ln -snf ../../common/module/common.tf common.tf 
  cd ../managed_disk_os && ln -snf ../../common/module/common_bypass_prefix.tf common_bypass_prefix.tf
  cd ../virtual_private_cloud && ln -snf ../../common/module/common.tf common.tf 
  cd ../nat && ln -snf ../../common/module/common.tf common.tf 
  cd ../firewall_rule && ln -snf ../../common/module/common.tf common.tf 
  cd ../folder && ln -snf ../../common/module/common_optional_prefix.tf common_optional_prefix.tf
  cd ../custom_role && ln -snf ../../common/module/common.tf common.tf 
  cd ../ha_vpn_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../storage && ln -snf ../../common/module/common.tf common.tf 
  cd ../generic_resource_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../project && ln -snf ../../common/module/common.tf common.tf 
  cd ../forwarding_rule && ln -snf ../../common/module/common.tf common.tf 
  cd ../cloud_function && ln -snf ../../common/module/common.tf common.tf 
  cd ../external_vpn_name && ln -snf ../../common/module/common.tf common.tf 
  cd ../log_sink && ln -snf ../../common/module/common.tf common.tf 
  cd ../service_account && ln -snf ../../common/module/common.tf common.tf 
  cd ../compute_address_internal_ip && ln -snf ../../common/module/common.tf common.tf 
  cd ../virtual_machine_instance_group && ln -snf ../../common/module/common.tf common.tf 
  cd ../vpc_svc_ctl && ln -snf ../../common/module/common.tf common.tf 
  cd ../health_check && ln -snf ../../common/module/common.tf common.tf 
  cd ../router && ln -snf ../../common/module/common.tf common.tf 
  echo "repaired use this command to check: "
  echo "ls -lR | grep ^l"
}


if [ $# -eq 0 ]; then
  echo "Options are: run, auth, apply_roles, tf_apply, upload_statefile, create_backends, create_csr, use_another_repo; Select run for full bootstrap"
  exit 1
else
case $1 in
  run)
  auth
  apply_roles
  tf_apply
  upload_statefile
  create_backends
  create_csr
  ;;
  
  auth)
  auth
  ;;

  apply_roles)
  apply_roles
  ;;

  tf_apply)
  tf_apply
  ;;

  upload_statefile)
  upload_statefile
  ;;

  create_backends)
  create_backends
  ;;

  create_csr)
  create_csr
  ;;

  use_another_repo)
  use_another_repo
  ;;

  repair_symlinks)
  repair_symlinks
  ;;

esac
fi
