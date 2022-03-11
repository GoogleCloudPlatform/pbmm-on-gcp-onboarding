# Getting Started
## Summary

This repo is used to create a landing zone. In order to do that some prerequisites are required to deploy the Terraform configurations.

 - A shell environment where Terraform, jq, and the GCloud SDK can all be installed. 
 - A Google Cloud Platform Organization, where the administrator running this code has Organizational Admin
 - Use the following link to automatically clone the public repo
 
[![Open this project in Google Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding&page=editor&tutorial=README.md)

#

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

#
1. Update `environments/bootstrap/organization-config.auto.tfvars` and `environments/bootstrap/bootstrap.auto.tfvars` with configuration values for your environment.
2. Update `environments/common/common.auto.tfvars` with values that will be shared between the non-prod and prod environments.
3. In the `environments/nonprod` and `environments/prod` directories, configure all variable files that end with *.auto.tfvars for configuration of the environments.
4. From bash, run the `bootstrap.sh` script from the `environments/bootstrap/` directory. The script will prompt for the domain and user that will be deploying the bootstrap resources. 

## Deploying the Landing zone
After all prerequisites are met, simply run the bootstrap.sh script in the landingzone/environments/bootstrap/ folder

```
cd environments/bootstrap
./bootstrap.sh
```

It will prompt you for information and launch both gcloud and terraform commands
