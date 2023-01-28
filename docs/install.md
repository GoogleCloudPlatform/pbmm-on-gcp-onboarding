# Landing Zone Installation
## Preparation
### Create GCP Organization
### Enable Billing
### Activate Billing
### Add IAM roles to Super Admin
### Start cloud shell
### Create project
```
# use a unique project name
export CC_PROJECT_ID=lz-tls
gcloud projects create $CC_PROJECT_ID --name="${CC_PROJECT_ID}" --set-as-default
gcloud config set project lz-tls
```
### Setup Billing
Either use the existing billing account for the landing zone projects or keep the bootstrap lz-tls on a different account

You may also add the current organization super admin as a billing account administrator on another billing account

<img width="655" alt="Screen Shot 2023-01-27 at 23 35 36" src="https://user-images.githubusercontent.com/24765473/215242203-a3b008d8-78aa-4738-9175-65e83d59a3b9.png">

```
export BILLING_ID=$(gcloud alpha billing projects describe $BOOT_PROJECT_ID '--format=value(billingAccountName)' | sed 's/.*\///')
```
or
```
export BILLING_ID=YOUR-BILLING-ID
```
### Associate Billing

```
gcloud beta billing projects link ${CC_PROJECT_ID} --billing-account ${BILLING_ID}
```

### Create root folder

- https://cloud.google.com/resource-manager/docs/creating-managing-folders#creating-folders
- https://cloud.google.com/sdk/gcloud/reference/organizations/add-iam-policy-binding

```
export ORG_ID=$(gcloud projects get-ancestors $CC_PROJECT_ID --format='get(id)' | tail -1)
export EMAIL=`gcloud config list account --format "value(core.account)"`
# set org level permission
gcloud organizations add-iam-policy-binding ${ORG_ID}  --member=user:${EMAIL} --role=roles/resourcemanager.folderAdmin
gcloud resource-manager folders create --display-name=LandingZone --organization=$ORG_ID

# note the folder id - sed 's/folders\/.*\///g')
name: 'folders/1095248971440'

export FOLDER_ID=1095248971440
```
<img width="1075" alt="Screen Shot 2023-01-27 at 23 51 03" src="https://user-images.githubusercontent.com/24765473/215242678-6f210d21-49e2-4fe9-bab0-672113c71fe8.png">

### Clone Repo
```
mkdir lz-tls
cd lz-tls
git clone https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding.git
cd pbmm-on-gcp-onboarding
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding (lz-tls)$ git status
On branch main
Your branch is up to date with 'origin/main'.

```


