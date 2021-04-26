######################################################################
## This Script will perform the below actions
## 1) Create a GCP project directly under the GCP Org
## 2) Provision a Terraform service account with required permissions in the seed project
######################VARIABLES
## 1) Dept naming convention. = This will be suffix of seed project dept-seed-project
## 2) Billing account ID to be used.
## 3) Organization ID
##########################USAGE
## sh GCP_seed_project.sh -d 'DEPT NAME' -o orgnaization_id -b 'Billing ID'
######################################################################


#!bin/bash

while getopts "d:o:b:" flag;
do
    case "${flag}" in
        d) dpt=${OPTARG};;
        o) org_id=${OPTARG};;
        b) billing_id=${OPTARG};;
    esac
done
seed_project_id="${dpt}-seed-project"
#echo "seed project id: $seed_project_id";
#echo "org id: $org_id";
#echo "billing id: $billing_id";

act=""




seed_gcp () {

tf="tfadmin-${dpt}"


#Step1 Create GCP seed Project
gcloud projects create "${seed_project_id}" --organization=${org_id}  --quiet

#Step 2 : Associate billing id with project
gcloud beta billing projects link "${seed_project_id}" --billing-account "${billing_id}" --quiet

#Step 3 Create Terraform service account
gcloud iam service-accounts create "${tf}" --display-name "Terraform admin account" --project=${seed_project_id} --quiet
act=`gcloud iam service-accounts list --project="${seed_project_id}" --filter=tfadmin --format="value(email)"`

#Step 4 Assign org level and project level role to TF account
gcloud organizations add-iam-policy-binding ${org_id}  --member=serviceAccount:${act} \
    --role=roles/billing.user \
    --role=roles/compute.networkAdmin \
    --role=roles/compute.xpnAdmin \
    --role=roles/iam.organizationRoleAdmin \
    --role=roles/orgpolicy.policyAdmin \
    --role=role/resourcemanager.folderAdmin \
    --role=roles/resourcemanager.organizationAdmin \
    --role=roles/resourcemanager.projectCreator \
    --role=roles/resourcemanager.projectDeleter \
    --role=roles/resourcemanager.projectIamAdmin \
    --role=roles/resourcemanager.projectMover   \
    --role=roles/orgpolicy.PolicyAdmin



}


main () {

seed_gcp
status=$?
if [ $status == 0 ]
then
echo "GCP seed project created project id: ""${seed_project_id} \n"
echo " Terraform Service account to be used for creating GCP landing zone = " "${act} \n"
echo " Please follow instructions to setup Terraform service account keys before launching Terraform scripts."
else
echo " GCP service account creation failed. Please debug and rerun"
fi
}

main
