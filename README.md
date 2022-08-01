# Getting Started

## Summary

This repo is used to create a PBMM compliant landing zone. In order to do that some prerequisites are required to deploy the Terraform configurations.

 - A shell environment where Terraform, jq, and the GCloud SDK can all be installed. 
 - A Google Cloud Platform Organization, where the administrator running this code has Organizational Admin
 - Use the following link to automatically clone the public repo to the cloudshell_open directory in shell.cloud.google.com
 
[![Open this project in Google Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding&page=editor&tutorial=README.md)


## Prerequisites
### Installs
The Bootstrap script is currently written for common linux distributions. It requires the following tools to be installed:
 - GCloud SDK
 - JQ (for JSON queries)
 - Terraform >= 1.0
 
[Install GCloud](https://cloud.google.com/sdk/docs/install#linux)

[Download Terraform](https://www.terraform.io/downloads.html)

Install jq (most linux distributions come with it already)
```
sudo apt-get install jq -q -y 
```

Move Terraform to a PATH usable location, usually like this:
```
VER=1.0.11
curl https://releases.hashicorp.com/terraform/$VER/terraform_$VER_linux_amd64.zip --output terraform_$VER_linux_amd64.zip
unzip terraform_$VER_llinux_amd64.zip
sudo cp ./terraform /usr/bin
sudo chmod +x /usr/bin/terraform
```
#
### Cloud Environment

This bootstrap assumes your Google account has Organization Administrator on the target GCP Organization

Some simple gcloud commands to check if you have permissions:

Using an authenticated gcloud sdk environment:
```
# Prints the active account
gcloud config list account --format "value(core.account)"

# What domain and what user?
DOMAIN=google.com
EMAIL=youremail@example.com
# or this: EMAIL=$(gcloud config list account --format "value(core.account)")

# Get the Org ID for IAM policy query
ORG_ID=$(gcloud organizations list --filter="DISPLAY_NAME:$DOMAIN" --format="value(ID)")

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
0. run the following to both authorize and set the bootstrap project
```
gcloud config set project <project_id>
```
1. run the writeids.sh script in this root folder directory to replace/unreplace your organization/billing/folder IDs in all tfvars below in 2-4 as (REPLACE_WITH_BILLING_ID, REPLACE_FOLDER_ID, REPLACE_ORGANIZATION_ID)
```
replace (fill b=billing, o=organization, f=folder)
./writeids.sh -c fill -b 1111-2222-3333 -o 444455559999 -f 012345678901
with project/billing/organization derived from the current default project
- note: when using multiple billing accounts - the billing account currently associated with the project will be used - use the above command to specify a different account or reassociate a different billing account to the project 

./writeids.sh -c fill -f 012345678901

revert (unfill)
./writeids.sh -c unfill -b 1111-2222-3333 -o 444455559999 -f 012345678901
```
2. Update `environments/bootstrap/organization-config.auto.tfvars` and `environments/bootstrap/bootstrap.auto.tfvars` with configuration values for your environment.
3. Update `environments/common/common.auto.tfvars` with values that will be shared between the non-prod and prod environments.
4. In the `environments/nonprod` and `environments/prod` directories, configure all variable files that end with *.auto.tfvars for configuration of the environments.
5. Increase your billing/project quotas above the default 5 and 8.  There will be 7 new projects created therefore the quota of 8 projects will need to increase to 20 if you are running other previous projects.   The 2nd quota to increase is the billing/project association quota - the default is 5 per billing account.  See the following example run where the quota was increased on the fly from 5 to 20 within 3 minutes by selecting "paid services" in the quota request https://support.google.com/code/contact/billing_quota_increase   The example is detailed here https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/97#issuecomment-1168703512   

## Deploying the Landing zone
After all prerequisites are met, from bash - run the `bootstrap.sh` script in the `environments/bootstrap/` folder.  

```
cd environments/bootstrap
./bootstrap.sh run
```

The script will prompt for the domain and user that will be deploying the bootstrap resources and launch both gcloud and terraform commands.

At the end of the script your git user email and name will be requested - you can use anything including your github details in this CSR.

Intially the 4 cloud build jobs will trigger/run (bootstrap, common, nonprod, prod) - they will fail as expected within 35 seconds until the base hierarchy bootstrap and common are run in sequence before nonprod and prod.

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

## Weekly Office Hours / Collaborators Meeting
 - Time: 1310-1325 EDT, 1710-1725 GMT, 1010-1025 PDT
 - Date: 10 May 2022, 25 May - every 2 weeks on Tuesday
 - Minutes: https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/issues/58#issuecomment-1122568232
 - Location: https://meet.google.com/qmh-uzqk-ssn?authuser=0&hs=122
 - Add to Calendar [![Add Google Meeting to your Calendar](https://www.gstatic.com/images/branding/product/2x/hh_calendar_64dp.png)](https://calendar.google.com/event?action=TEMPLATE&tmeid=N25jaTFldWVpdDl0ZGttdDFuZXE1aGpldjZfMjAyMjA1MjRUMTcxMDAwWiBmbWljaGFlbG9icmllbkBnb29nbGUuY29t&tmsrc=fmichaelobrien%40google.com&scp=ALL)

## Disclaimer

This is not an officially supported Google product.
