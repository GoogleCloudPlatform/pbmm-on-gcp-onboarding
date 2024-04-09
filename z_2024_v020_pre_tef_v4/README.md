# Releases

## 0.1: main
- as of 202311 the main branch has been upsourced with private LZ modifications - however the branch is currently still being stabilized
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/tree/main
## 0.1: dev
- as of 202311 the 332 branch previously off the main branch from 20230917 is the stable branch (without private LZ modifications added to main) - use this branch if you are an existing LZ V1 partner
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/tree/332-dev-prov-client-v20230917

## Alternative Landing Zone - Fortigate Accelerator
- There is a light terraform based landing zone based around a Fortinet HA cluster in the following directory
- https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/tree/main/2024_fortigate_accelerator

## Alternative Landing Zone V2
- There is a V2 Landing Zone managed by SSC based on the Kubernetes Config Controller.
- https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit

# Getting Started

## Summary

This repository is used to create a PBMM compliant landing zone. In order to do that some prerequisites are required to deploy the Terraform configurations.

 - A shell environment where Terraform, jq, and the GCloud SDK can all be installed. 
 - A Google Cloud Platform Organization, where the administrator running this code has Organizational Admin
 - Use the following link to automatically clone the public repo to the cloudshell_open directory in shell.cloud.google.com
 
[![Open this project in Google Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding&page=editor&tutorial=README.md)

## Prerequisites
- Super admin Google Cloud User
- A domain to use for the organization name (usually subdomain.domain.tld)
- Access to the domain zone for organization TXT record validation

See the following example of a landing zone deployment.
<img width="1007" alt="pbmm_lz_organizational_structure" src="https://user-images.githubusercontent.com/94715080/186011646-bec31e28-5408-46fb-8f4a-0ab232605e5f.png">


### Installs
The Bootstrap script is currently written for common linux distributions. It requires the following tools to be installed:
 - GCloud SDK
 - JQ (for JSON queries)
 - Terraform >= 1.3.0
 
[Install GCloud](https://cloud.google.com/sdk/docs/install#linux)

[Download Terraform](https://www.terraform.io/downloads.html)

Install jq (most linux distributions come with it already)
```
sudo apt-get install jq -q -y 
```

Move Terraform to a PATH usable location, usually like this:

Until advised otherwise - keep the version between "1.3.0 and 1.6.0" just for Bootstrap Process.
Replace VER above with a desired value, its been tested upto 1.6.0, so any value between >= 1.3.0 <= 1.6.0 is ok.
```
VER=1.3.0
wget https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip
unzip terraform_${VER}_linux_amd64.zip
cp /usr/bin/terraform terraform_original
sudo cp ./terraform /usr/bin
sudo chmod +x /usr/bin/terraform
```

#### Verify Terraform Version
```
terraform --version
```

### Cloud Environment

This bootstrap assumes your Google account has the Organization Administrator role on the target GCP Organization

Some simple gcloud commands to check if you have permissions:

Using an authenticated gcloud sdk environment:
```
# Prints the active account
gcloud config list account --format "value(core.account)"
```
```
# What domain and what user?
DOMAIN=google.com
EMAIL=youremail@example.com 
# Or this:
EMAIL=$(gcloud config list account --format "value(core.account)")
```
```
# Get the Org ID for IAM policy query
ORG_ID=$(gcloud organizations list --filter="DISPLAY_NAME:$DOMAIN" --format="value(ID)")
```
```
# search for the email in the IAM policy
gcloud organizations get-iam-policy $ORG_ID --filter="bindings.role:roles/resourcemanager.organizationAdmin" --format="value(bindings.members)" | grep $EMAIL
```

#### Using the Bootstrap Script

## Please read this warning 

 This bootstrap script is meant to be run by **one elevated user, in one sitting, with the permanent naming convention** to be used. 
 
The reason for this are: 
- Permissions for that user are temporary, changing users before the automation takes over operations locks other users out of this process
- Accomplishing this is one sitting allows all users to contribute to repairing any issues in the environment by contributing code
- Project_Ids are globally consistent across all of Google Cloud Platform, projects take 7 days to delete and wont release that unique name until fully deleted. 

# Prerequisites
0. Run the following to both authorize and set the bootstrap project
```
gcloud config set project <project_id>
```
1. Enable the required APIs for this Bootstrap project
```
gcloud services enable \
    cloudresourcemanager.googleapis.com \
    cloudbilling.googleapis.com \
    cloudkms.googleapis.com \
    cloudbuild.googleapis.com
```
2. run the writeids.sh script in this root folder directory to replace/unreplace your organization/billing/folder IDs in all tfvars below in 2-4 as (REPLACE_WITH_BILLING_ID, REPLACE_FOLDER_ID, REPLACE_ORGANIZATION_ID)
```
replace (fill b=billing, o=organization, f=folder)
./writeids.sh -c fill -b 1111-2222-3333 -o 444455559999 -f 012345678901
with project/billing/organization derived from the current default project
- note: when using multiple billing accounts - the billing account currently associated with the project will be used - use the above command to specify a different account or reassociate a different billing account to the project 

./writeids.sh -c fill -f 012345678901

revert (unfill)
./writeids.sh -c unfill -b 1111-2222-3333 -o 444455559999 -f 012345678901
```
3. Update `environments/bootstrap/organization-config.auto.tfvars` and `environments/bootstrap/bootstrap.auto.tfvars` with configuration values for your environment.
4. Update `environments/common/common.auto.tfvars` with values that will be shared between the non-prod and prod environments.
5. In the `environments/nonprod` and `environments/prod` directories, configure all variable files that end with *.auto.tfvars for configuration of the environments.
6. Increase your billing/project quotas above the default 5 and 8.  There will be 7 new projects created therefore the quota of 8 projects will need to increase to 20 if you are running other previous projects.   The 2nd quota to increase is the billing/project association quota - the default is 5 per billing account.  See the following example run where the quota was increased on the fly from 5 to 20 within 3 minutes by selecting "paid services" in the quota request https://support.google.com/code/contact/billing_quota_increase   The example is detailed here https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/97#issuecomment-1168703512   

## Deploying the Landing zone
After all prerequisites are met, from bash - run the `bootstrap.sh` script in the `environments/bootstrap/` folder.  

```
cd environments/bootstrap
./bootstrap.sh run
```

The script will prompt for the domain and user that will be deploying the bootstrap resources and launch both gcloud and terraform commands.

At the end of the script your git user email and name will be requested - you can use anything including your github details in this CSR.


## Navigate to Admin Console
After all prerequisites are met, from bash - run the `bootstrap.sh` script in the `environments/bootstrap/` folder. 

Go to the project that was just created by selecting resource from the top left corner of the Google cloud console.
Then navigate to the IAM & Admin of that project then select IAM. Copy the Terraform deployment service account {tf-deploy@{dept-owner-code}.iam.gserviceaccount.com}

Navigate to https://admin.google.com Then On the left side of the panel, select @ Accounts then click on Admin roles.
Under Admin roles, select Groups Admins then finally add the Terraform deployment service account to this Group.

## Deploying in Cloud Build
Navigate back to https://console.google.com Then search for Cloud build. Ensure you are in the right project that was just created from the bootstrap run command.

Initially the 4 cloud build jobs will trigger/run (bootstrap, common, nonprod, prod) - they will fail as expected within 35 seconds until the base hierarchy bootstrap and common are run in sequence before nonprod and prod.

The  **Expected** run time will be around 23 min (2 min for bootstrap, 9 min for common, 6 min for non-prod and 6 min for prod).  Ideally to get the builds to sequence - git commit comfig changes in common, non-prod and prod in 3 separate sequenced commits.

![20220801_cloudnuage_pbmm_cloudbuild_run_Screenshot 2022-08-01 114631](https://user-images.githubusercontent.com/24765473/182189431-d285ec14-4f7d-41be-88c6-d62fd525e93f.png)


To force sequenced builds the first time and to exercise the CSR/Cloud-build queue - modify any auto.tfvars file (a CR or space) in bootstrap, common, non-prod and prod in sequence until all builds are green.  

<img width="1340" alt="Screen Shot 2022-06-28 at 8 56 04 AM" src="https://user-images.githubusercontent.com/94715080/176244541-79aa8822-b0bb-4162-8a23-2230d39c0348.png">

At this point the landing zone is up and ready and any normal changes like a firewall change will trigger the appropriate build via a CSR commit/push.


## Asset Inventory
https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/docs/google-cloud-asset-inventory.md

## Compliance and Governance

- [Google Cloud ITSG-33 Security Controls Coverage](docs/google-cloud-security-controls.md)
- Google Public Sector - https://cloud.google.com/blog/topics/public-sector/announcing-google-public-sector
- Google Cybersecurity Action Team - https://cloud.google.com/security/gcat

## Monthly Office Hours / Collaborators Meeting
- TBD 2023 May

## Disclaimer

This is not an officially supported Google product.
