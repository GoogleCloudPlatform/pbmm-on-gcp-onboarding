#!/bin/bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This Script will perform the below actions
# 1) set 3 types of variables inside all tfvar content
# 2) unset variables above (to be able to obfuscate code changes and git commit without posting org/billing/folder ids


set -e

modify()
{

  array=( environments/bootstrap/bootstrap.auto.tfvars environments/bootstrap/organization-config.auto.tfvars environments/common/common.auto.tfvars environments/common/logging-center.auto.tfvars  environments/common/monitoring-center.auto.tfvars  environments/nonprod/nonp-network.auto.tfvars  environments/nonprod/monitoring-center.auto.tfvars  environments/nonprod/nonp-projects.auto.tfvars  environments/common/perimeter-network.auto.tfvars environments/prod/prod-network.auto.tfvars environments/prod/monitoring-center.auto.tfvars  environments/prod/prod-projects.auto.tfvars )
  for i in "${array[@]}"
      do
	      echo "$i pass - fill:${FILL}"
        # OSX required empty arg after -i
        if [[ $FILL == true ]]
        then
            # OSX requires ''
            #sed -i '' "s/${BILLING_ID_SEARCH}/${BILLING_ID}/g" $i
            sed -i "s/REPLACE_WITH_BILLING_ID/${REPLACE_WITH_BILLING_ID}/g" $i
            sed -i "s/REPLACE_ORGANIZATION_ID/${REPLACE_ORGANIZATION_ID}/g" $i
            sed -i "s/REPLACE_FOLDER_ID/${REPLACE_FOLDER_ID}/g" $i
            sed -i "s/REPLACE_WITH_BOOTSTRAP_USD/${REPLACE_WITH_BOOTSTRAP_USD}/g" $i
            sed -i "s/REPLACE_WITH_CSR/${REPLACE_WITH_CSR}/g" $i
            sed -i "s/REPLACE_BOOTSTRAP_EMAIL/${REPLACE_BOOTSTRAP_EMAIL}/g" $i
            sed -i "s/REPLACE_WITH_COMMON_BUCKET/${REPLACE_WITH_COMMON_BUCKET}/g" $i
            sed -i "s/REPLACE_WITH_NONPROD_BUCKET/${REPLACE_WITH_NONPROD_BUCKET}/g" $i
            sed -i "s/REPLACE_WITH_PROD_BUCKET/${REPLACE_WITH_PROD_BUCKET}/g" $i
            sed -i "s/REPLACE_CLOUD_BUILD_ADMINS/${REPLACE_CLOUD_BUILD_ADMINS}/g" $i
            sed -i "s/REPLACE_CLOUD_BUILD_VIEW/${REPLACE_CLOUD_BUILD_VIEW}/g" $i
            sed -i "s/REPLACE_DEPT_CODE/${REPLACE_DEPT_CODE}/g" $i
            sed -i "s/REPLACE_OWNER/${REPLACE_OWNER}/g" $i
            sed -i "s/REPLACE_CONTACTS_ORG_EMAIL/${REPLACE_CONTACTS_ORG_EMAIL}/g" $i
            sed -i "s/REPLACE_AUDIT_PROJECT_USD/${REPLACE_AUDIT_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_AUDIT_BUCKET_NAME/${REPLACE_AUDIT_BUCKET_NAME}/g" $i
            sed -i "s/REPLACE_AUDIT_SINK_NAME/${REPLACE_AUDIT_SINK_NAME}/g" $i
            sed -i "s/REPLACE_AUDIT_BUCKET_VIEW_EMAIL/${REPLACE_AUDIT_BUCKET_VIEW_EMAIL}/g" $i
            sed -i "s/REPLACE_AUDIT_IAM_EMAIL/${REPLACE_AUDIT_IAM_EMAIL}/g" $i
            sed -i "s/REPLACE_FOLDER_IAM_EMAIL/${REPLACE_FOLDER_IAM_EMAIL}/g" $i
            sed -i "s/REPLACE_ORG_IAM_EMAIL/${REPLACE_ORG_IAM_EMAIL}/g" $i
            sed -i "s/REPLACE_GUARDRAILS_PROJECT_USD/${REPLACE_GUARDRAILS_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_NONPROD_PROJECT_USD/${REPLACE_NONPROD_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_PROD_PROJECT_USD/${REPLACE_PROD_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_MONITORING_VIEW_EMAIL/${REPLACE_MONITORING_VIEW_EMAIL}/g" $i
            sed -i "s/REPLACE_MONITORING_PROJECT_USD/${REPLACE_MONITORING_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_LOGGING_VIEW_EMAIL/${REPLACE_LOGGING_VIEW_EMAIL}/g" $i
            sed -i "s/REPLACE_LOGGING_ORG_PROJECT_USD/${REPLACE_LOGGING_ORG_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_LOGGING_ORG_BUCKET/${REPLACE_LOGGING_ORG_BUCKET}/g" $i
            sed -i "s/REPLACE_LOGGING_ORG_DEST_BUCKET/${REPLACE_LOGGING_ORG_DEST_BUCKET}/g" $i
            sed -i "s/REPLACE_LOGGING_DEV_PROJECT_USD/${REPLACE_LOGGING_DEV_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_LOGGING_DEV_BUCKET/${REPLACE_LOGGING_DEV_BUCKET}/g" $i
            sed -i "s/REPLACE_LOGGING_DEV_DEST_BUCKET/${REPLACE_LOGGING_DEV_DEST_BUCKET}/g" $i
            sed -i "s/REPLACE_LOGGING_UAT_USD/${REPLACE_LOGGING_UAT_USD}/g" $i
            sed -i "s/REPLACE_LOGGING_UAT_BUCKET/${REPLACE_LOGGING_UAT_BUCKET}/g" $i
            sed -i "s/REPLACE_LOGGING_UAT_DEST_BUCKET/${REPLACE_LOGGING_UAT_DEST_BUCKET}/g" $i
            sed -i "s/REPLACE_LOGGING_PROD_USD/${REPLACE_LOGGING_PROD_USD}/g" $i
            sed -i "s/REPLACE_LOGGING_PROD_BUCKET/${REPLACE_LOGGING_PROD_BUCKET}/g" $i
            sed -i "s/REPLACE_LOGGING_PROD_DEST_BUCKET/${REPLACE_LOGGING_PROD_DEST_BUCKET}/g" $i
            sed -i "s/REPLACE_PUBLIC_PERIMETER_PROJECT_USD/${REPLACE_PUBLIC_PERIMETER_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_PRIV_PERIMETER_PROJECT_USD/${REPLACE_PRIV_PERIMETER_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_HA_PERIMETER_PROJECT_USD/${REPLACE_HA_PERIMETER_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_MGMT_PERIMETER_PROJECT_USD/${REPLACE_MGMT_PERIMETER_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_MONITORING_VIEW_EMAIL/${REPLACE_MONITORING_VIEW_EMAIL}/g" $i
            sed -i "s/REPLACE_LOGGING_VIEW_EMAIL/${REPLACE_LOGGING_VIEW_EMAIL}/g" $i
            sed -i "s/REPLACE_PUBLIC_PERIMETER_PROJECT_USD/${REPLACE_PUBLIC_PERIMETER_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_PRIV_PERIMETER_PROJECT_USD/${REPLACE_PRIV_PERIMETER_PROJECT_USD}/g" $i
            sed -i "s/REPLACE_MONITORING_PROJECT_PROD_USD/${REPLACE_MONITORING_PROJECT_PROD_USD}/g" $i
            sed -i "s/REPLACE_MONITORING_PROJECT_DEV_USD/${REPLACE_MONITORING_PROJECT_DEV_USD}/g" $i   
            sed -i "s/REPLACE_MONITORING_PROJECT_UAT_USD/${REPLACE_MONITORING_PROJECT_UAT_USD}/g" $i 
        else
            sed -i "s/${REPLACE_WITH_BILLING_ID}/REPLACE_WITH_BILLING_ID/g" $i
            sed -i "s/${REPLACE_ORGANIZATION_ID}/REPLACE_ORGANIZATION_ID/g" $i
            sed -i "s/${REPLACE_FOLDER_ID}/REPLACE_FOLDER_ID/g" $i
            sed -i "s/${REPLACE_WITH_BOOTSTRAP_USD}/REPLACE_WITH_BOOTSTRAP_USD/g" $i
            sed -i "s/${REPLACE_WITH_CSR}/REPLACE_WITH_CSR/g" $i
            sed -i "s/${REPLACE_BOOTSTRAP_EMAIL}/REPLACE_BOOTSTRAP_EMAIL/g" $i
            sed -i "s/${REPLACE_WITH_COMMON_BUCKET}/REPLACE_WITH_COMMON_BUCKET/g" $i
            sed -i "s/${REPLACE_WITH_NONPROD_BUCKET}/REPLACE_WITH_NONPROD_BUCKET/g" $i
            sed -i "s/${REPLACE_WITH_PROD_BUCKET}/REPLACE_WITH_PROD_BUCKET/g" $i
            sed -i "s/${REPLACE_CLOUD_BUILD_ADMINS}/REPLACE_CLOUD_BUILD_ADMINS/g" $i
            sed -i "s/${REPLACE_CLOUD_BUILD_VIEW}/REPLACE_CLOUD_BUILD_VIEW/g" $i
            sed -i "s/${REPLACE_DEPT_CODE}/REPLACE_DEPT_CODE/g" $i
            sed -i "s/${REPLACE_OWNER}/REPLACE_OWNER/g" $i
            sed -i "s/${REPLACE_CONTACTS_ORG_EMAIL}/REPLACE_CONTACTS_ORG_EMAIL/g" $i
            sed -i "s/${REPLACE_AUDIT_PROJECT_USD}/REPLACE_AUDIT_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_AUDIT_BUCKET_NAME}/REPLACE_AUDIT_BUCKET_NAME/g" $i
            sed -i "s/${REPLACE_AUDIT_SINK_NAME}/REPLACE_AUDIT_SINK_NAME/g" $i
            sed -i "s/${REPLACE_AUDIT_BUCKET_VIEW_EMAIL}/REPLACE_AUDIT_BUCKET_VIEW_EMAIL/g" $i
            sed -i "s/${REPLACE_AUDIT_IAM_EMAIL}/REPLACE_AUDIT_IAM_EMAIL/g" $i
            sed -i "s/${REPLACE_FOLDER_IAM_EMAIL}/REPLACE_FOLDER_IAM_EMAIL/g" $i
            sed -i "s/${REPLACE_ORG_IAM_EMAIL}/REPLACE_ORG_IAM_EMAIL/g" $i
            sed -i "s/${REPLACE_GUARDRAILS_PROJECT_USD}/REPLACE_GUARDRAILS_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_NONPROD_PROJECT_USD}/REPLACE_NONPROD_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_PROD_PROJECT_USD}/REPLACE_PROD_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_MONITORING_VIEW_EMAIL}/REPLACE_MONITORING_VIEW_EMAIL/g" $i
            sed -i "s/${REPLACE_MONITORING_PROJECT_USD}/REPLACE_MONITORING_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_LOGGING_VIEW_EMAIL}/REPLACE_LOGGING_VIEW_EMAIL/g" $i
            sed -i "s/${REPLACE_LOGGING_ORG_PROJECT_USD}/REPLACE_LOGGING_ORG_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_LOGGING_ORG_BUCKET}/REPLACE_LOGGING_ORG_BUCKET/g" $i
            sed -i "s/${REPLACE_LOGGING_ORG_DEST_BUCKET}/REPLACE_LOGGING_ORG_DEST_BUCKET/g" $i
            sed -i "s/${REPLACE_LOGGING_DEV_PROJECT_USD}/REPLACE_LOGGING_DEV_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_LOGGING_DEV_BUCKET}/REPLACE_LOGGING_DEV_BUCKET/g" $i
            sed -i "s/${REPLACE_LOGGING_DEV_DEST_BUCKET}/REPLACE_LOGGING_DEV_DEST_BUCKET/g" $i
            sed -i "s/${REPLACE_LOGGING_UAT_USD}/REPLACE_LOGGING_UAT_USD/g" $i
            sed -i "s/${REPLACE_LOGGING_UAT_BUCKET}/REPLACE_LOGGING_UAT_BUCKET/g" $i
            sed -i "s/${REPLACE_LOGGING_UAT_DEST_BUCKET}/REPLACE_LOGGING_UAT_DEST_BUCKET/g" $i
            sed -i "s/${REPLACE_LOGGING_PROD_USD}/REPLACE_LOGGING_PROD_USD/g" $i
            sed -i "s/${REPLACE_LOGGING_PROD_BUCKET}/REPLACE_LOGGING_PROD_BUCKET/g" $i
            sed -i "s/${REPLACE_LOGGING_PROD_DEST_BUCKET}/REPLACE_LOGGING_PROD_DEST_BUCKET/g" $i
            sed -i "s/${REPLACE_PUBLIC_PERIMETER_PROJECT_USD}/REPLACE_PUBLIC_PERIMETER_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_PRIV_PERIMETER_PROJECT_USD}/REPLACE_PRIV_PERIMETER_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_HA_PERIMETER_PROJECT_USD}/REPLACE_HA_PERIMETER_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_MGMT_PERIMETER_PROJECT_USD}/REPLACE_MGMT_PERIMETER_PROJECT_USD/g" $i
            sed -i "s/${REPLACE_MONITORING_PROJECT_PROD_USD}/REPLACE_MONITORING_PROJECT_PROD_USD/g" $i
            sed -i "s/${REPLACE_MONITORING_PROJECT_DEV_USD}/REPLACE_MONITORING_PROJECT_DEV_USD/g" $i
            sed -i "s/${REPLACE_MONITORING_PROJECT_UAT_USD}/REPLACE_MONITORING_PROJECT_UAT_USD/g" $i
        fi
      done
}

usage()
{
    echo "usage: options:<c|o|b|f>"
    echo "example: ./writeids.sh -c fill|unfill -o org_id -b billing_id -f folder_id"
    echo "example: ./writeids.sh -c unfill -b 1111-2222-3333 -o 4444-5555-9999 -f 012345678901"
    echo "example: ./writeids.sh -c fill -b 1111-2222-3333 -o 4444-5555-9999 -f 012345678901"
    echo "example: project only (org/billing derived): ./writeids.sh -c fill -p michael-proj-id -f 012345678901"
    echo "example: no project (project/org/billing derived): ./writeids.sh -c fill -f 012345678901"
}

unsetids() 
{
   FILL=false
   echo "reverting IDs: billing: ${BILLING_ID} organization: ${ORGANIZATION_ID} folder: ${FOLDER_ID} to placeholders"
   modify 
}

setids() 
{
   FILL=true
   echo "replacing IDs: billing: ${BILLING_ID} organization: ${ORGANIZATION_ID} folder: ${FOLDER_ID} from placeholders"
   modify 
}

no_args="true"
PROJECT_ID=
COMMAND=fill
BILLING_ID_SEARCH=REPLACE_WITH_BILLING_ID 
ORGANIZATION_ID_SEARCH=REPLACE_ORGANIZATION_ID 
FOLDER_ID_SEARCH=REPLACE_FOLDER_ID 
BILLING_ID=
ORGANIZATION_ID= 
FOLDER_ID= 
FILL=true
#FILL=false

while getopts "p:c:e:" flag;
do
    case "${flag}" in
        c) COMMAND=${OPTARG};;
        p) PROJECT_ID=${OPTARG};;
        e) ENV=${OPTARG};;
        *) usage
           exit 1
           ;;
    esac
    no_args="false"
done

  

  # get current project
  source $ENV
  
  
# Exit script and print usage if no arguments are passed.
if [[ $no_args == true ]]; then
    usage
    exit 1
fi

if [[ $COMMAND == "unfill" ]]
then
    unsetids
else
    setids
fi