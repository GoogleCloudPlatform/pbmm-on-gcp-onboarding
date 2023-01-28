# Landing Zone Installation
## Preparation
### Create GCP Organization
### Enable Billing
### Activate Billing
### Add IAM roles to Super Admin
#### Existing Roles
```
Organization Administrator
Project Creator
```
#### Additional Roles Added by bootstrap script

```
Billing Account Viewer
Folder Admin
Folder Creator
Organization Policy Administrator
Organization Viewer
Project Billing Manager
```

#### Roles to be added to the script
```
Service Account Token Creator
```

#### To Be Retrofitted roles
- remove owner after determining the smaller subset of 7k permissions
```
Owner
```
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
### Run writeids.sh fill script
```
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding (lz-tls)$ export FOLDER_ID=1095248971440
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding (lz-tls)$ ./writeids.sh -c fill -f $FOLDER_ID
Derived organization_id: 131880894992
Derived billing_id: 019283-6F1AB5-7AD576
replacing IDs: billing: 019283-6F1AB5-7AD576 organization: 131880894992 folder: 1095248971440 from placeholders
environments/bootstrap/bootstrap.auto.tfvars pass - fill:true
environments/bootstrap/organization-config.auto.tfvars pass - fill:true
environments/common/common.auto.tfvars pass - fill:true
environments/nonprod/nonp-network.auto.tfvars pass - fill:true
environments/common/perimeter-network.auto.tfvars pass - fill:true
environments/prod/prod-network.auto.tfvars pass - fill:true
```

### Check diff
```
git diff > diff_20230127.txt

diff --git a/environments/bootstrap/bootstrap.auto.tfvars b/environments/bootstrap/bootstrap.auto.tfvars
index 97d8e9a..e47062b 100644
--- a/environments/bootstrap/bootstrap.auto.tfvars
+++ b/environments/bootstrap/bootstrap.auto.tfvars
@@ -26,10 +26,10 @@
 bootstrap = {
   userDefinedString           = "" # REQUIRED EDIT Appended to project name/id ##needs to be lower case and min. 3 characters
   additionalUserDefinedString = "" # OPTIONAL EDIT Additional appended string
-  billingAccount              = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Billing Account in the format of ######-######-######
+  billingAccount              = "019283-6F1AB5-7AD576" # REQUIRED EDIT Billing Account in the format of ######-######-######
   # switch out root_node depending on whether you are running directly off the organization or a folder
-  #parent                      = "organizations/REPLACE_ORGANIZATION_ID" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
-  parent                      = "folders/REPLACE_FOLDER_ID" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
+  #parent                      = "organizations/131880894992" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
+  parent                      = "folders/1095248971440" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
   terraformDeploymentAccount  = "" # REQUIRED EDIT Name of a service account to be created (alphanumeric before the at sign) used to deploy the terraform code
   bootstrapEmail              = "user:" # REQUIRED EDIT In the form of 'user:user@email.com
   region                      = "northamerica-northeast1" # REQUIRED EDIT Region name. northamerica-northeast1
diff --git a/environments/bootstrap/organization-config.auto.tfvars b/environments/bootstrap/organization-config.auto.tfvars
index 3f328d2..d275e72 100644
--- a/environments/bootstrap/organization-config.auto.tfvars
+++ b/environments/bootstrap/organization-config.auto.tfvars
@@ -17,7 +17,7 @@
 
 
 organization_config = {
-  org_id          = "REPLACE_ORGANIZATION_ID" # REQUIRED EDIT Numeric portion only '#############'"
+  org_id          = "131880894992" # REQUIRED EDIT Numeric portion only '#############'"
   default_region  = "northamerica-northeast1" # REQUIRED EDIT Cloudbuild Region - default to na-ne1 or 2
   department_code = "" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
   owner           = "" # REQUIRED EDIT Used in naming standard
@@ -25,12 +25,12 @@ organization_config = {
   location        = "northamerica-northeast1" # REQUIRED EDIT Location used for resources. Currently northamerica-northeast1 is available
   labels          = {} # REQUIRED EDIT Object used for resource labels
   # switch out root_node depending on whether you are running directly off the organization or a folder
-  #root_node       = "organizations/REPLACE_ORGANIZATION_ID" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
-  root_node       = "folders/REPLACE_FOLDER_ID" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
+  #root_node       = "organizations/131880894992" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
+  root_node       = "folders/1095248971440" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
   
   contacts = {
     "user@email.com" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
   }
-  billing_account = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Format of ######-######-######
+  billing_account = "019283-6F1AB5-7AD576" # REQUIRED EDIT Format of ######-######-######
 }
 

diff --git a/environments/common/common.auto.tfvars b/environments/common/common.auto.tfvars
index 959836d..ae73d0c 100644
--- a/environments/common/common.auto.tfvars
+++ b/environments/common/common.auto.tfvars
@@ -34,8 +34,8 @@ org_policies = {
 }
 folders = {
    # switch out parent depending on whether you are running directly off the organization or a folder
-  #parent = "organizations/REPLACE_ORGANIZATION_ID" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
-  parent = "folders/REPLACE_FOLDER_ID" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
+  #parent = "organizations/131880894992" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
+  parent = "folders/1095248971440" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
   names  = ["Infrastructure", "Sandbox", "Workloads", "Audit and Security", "Automation", "Shared Services"] # Production, NonProduction and Platform are included in the module
   subfolders_1 = {
     SharedInfrastructure = "Infrastructure"
@@ -63,7 +63,7 @@ access_context_manager = { # REQUIRED OBJECT. VPC Service Controls object.
 audit = {                                  # REQUIRED OBJECT. Must include an audit object.
   user_defined_string            = "audit" # REQUIRED EDIT. Must be globally unique, used for the audit project
   additional_user_defined_string = ""      # OPTIONAL EDIT. Optionally append a value to the end of the user defined string.
-  billing_account                = "REPLACE_WITH_BILLING_ID"      # REQUIRED EDIT. Define the audit billing account
+  billing_account                = "019283-6F1AB5-7AD576"      # REQUIRED EDIT. Define the audit billing account
   audit_streams = {
     prod = {
       bucket_name          = ""                     # REQUIRED EDIT. Must be globally unique, used for the audit bucket
@@ -114,7 +114,7 @@ folder_iam = [
 organization_iam = [
   {
     member       = "group:group@test.domain.net" # REQUIRED EDIT. user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
-    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
+    organization = "131880894992" #Insert your Ord ID here, format ############
     roles = [
       "roles/viewer",
     ]
@@ -123,7 +123,7 @@ organization_iam = [
 
 guardrails = {
   user_defined_string = "guardrails" # Optional EDIT. Must be unique. Defines the guardrails project in form department_codeEnvironmente-owner-user_defined_string
-  billing_account     = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT. Billing Account in the format of ######-######-######
+  billing_account     = "019283-6F1AB5-7AD576" # REQUIRED EDIT. Billing Account in the format of ######-######-######
   org_id_scan_list = [     # REQUIRED EDIT. Organization Id list for service account to have cloud asset viewer permission
   ]
   org_client = false #Set to true if deploying remote client landing zone.  Otherwise set to false if deploying for core organization landing zone.
diff --git a/environments/common/perimeter-network.auto.tfvars b/environments/common/perimeter-network.auto.tfvars
index de86abe..e151dc9 100644
--- a/environments/common/perimeter-network.auto.tfvars
+++ b/environments/common/perimeter-network.auto.tfvars
@@ -19,7 +19,7 @@
 public_perimeter_net = {
   user_defined_string            = "prd" # REQUIRED EDIT must contribute to being globally unique
   additional_user_defined_string = "perim" # OPTIONAL EDIT check 61 char aggregate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   labels                         = {}
   networks = [
@@ -55,7 +55,7 @@ public_perimeter_net = {
 private_perimeter_net = {
   user_defined_string            = "prod" # must be globally unique
   additional_user_defined_string = "priper" # check 61 char aggregate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   networks = [
     {
@@ -90,7 +90,7 @@ private_perimeter_net = {
 ha_perimeter_net = {
   user_defined_string            = "prod" # must be globally unique
   additional_user_defined_string = "perim" # check 61 char agreggate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   networks = [
     {
@@ -126,7 +126,7 @@ ha_perimeter_net = {
 management_perimeter_net = {
   user_defined_string            = "prod" # must be globally unique
   additional_user_defined_string = "perim" # check 61 char aggregate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   networks = [
     {
diff --git a/environments/nonprod/nonp-network.auto.tfvars b/environments/nonprod/nonp-network.auto.tfvars
index 64c099c..e7e0c0c 100644
--- a/environments/nonprod/nonp-network.auto.tfvars
+++ b/environments/nonprod/nonp-network.auto.tfvars
@@ -19,7 +19,7 @@
 nonprod_host_net = {
   user_defined_string            = "" # Used to create project name - must be globally unique in aggregate
   additional_user_defined_string = "" # check total 61 char limit with this addition
-  billing_account                = "REPLACE_WITH_BILLING_ID" #"######-######-######"
+  billing_account                = "019283-6F1AB5-7AD576" #"######-######-######"
   services                       = ["logging.googleapis.com" , "dns.googleapis.com"]
   networks = [
     {
diff --git a/environments/prod/prod-network.auto.tfvars b/environments/prod/prod-network.auto.tfvars
index 5d80cb4..eba143a 100644
--- a/environments/prod/prod-network.auto.tfvars
+++ b/environments/prod/prod-network.auto.tfvars
@@ -19,7 +19,7 @@
 prod_host_net = {
   user_defined_string            = "prod" # Must be globally unique. Used to create project name
   additional_user_defined_string = "host1"
-  billing_account                = "REPLACE_WITH_BILLING_ID" ######-######-###### # required
+  billing_account                = "019283-6F1AB5-7AD576" ######-######-###### # required
   services                       = ["logging.googleapis.com"]
   networks = [
     {

```

### Manual Edits
#### bootstrap.auto.tfvar
```
bootstrap = {
  userDefinedString           = "tls" # REQUIRED EDIT Appended to project name/id ##needs to be lower case and min. 3 characters
  additionalUserDefinedString = "dv" # OPTIONAL EDIT Additional appended string
  terraformDeploymentAccount  = "tftlssa" # REQUIRED EDIT Name of a service account to be created (alphanumeric before the at sign) used to deploy the terraform code
  bootstrapEmail              = "user:root@terraform.landing.systems" # REQUIRED EDIT In the form of 'user:user@email.com
  cloud_source_repo_name      = "tlscsr" # REQUIRED EDIT CSR used as a mirror for code
  
  tfstate_buckets = {
    common = {
      name = "tlslzcom" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
      name = "tlslznprd" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
      name = "tlslzprd" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only

cloud_build_admins = [
  "user:root@terraform.landing.systems", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
  "user:root@terraform.landing.systems", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
```
#### organization-config.auto.tfvars
```
organization_config = {
  department_code = "Ts" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
  owner           = "tls" # REQUIRED EDIT Used in naming standard
  contacts = {
    "root@terraform.landing.systems" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
```
#### common.auto.tfvars
```
access_context_manager = { # REQUIRED OBJECT. VPC Service Controls object. 
  user_defined_string = "tlsacm" # Optional EDIT.

audit = {                                  # REQUIRED OBJECT. Must include an audit object.
  additional_user_defined_string = "tls"      # OPTIONAL EDIT. Optionally append a value to the end of the user defined string.
  audit_streams = {
    prod = {
      bucket_name          = "audittls"                     # REQUIRED EDIT. Must be globally unique, used for the audit bucket
      sink_name            = "tlssink1"                     # REQUIRED EDIT. Must be unique across organization
      bucket_viewer        = "user:root@terraform.landing.systems" # REQUIRED EDIT. 

audit_project_iam = [ #REQUIRED EDIT. At least one object is required. The member cannot be the same for multiple objects.
    member = "user:root@terraform.landing.systems" #REQUIRED EDIT

folder_iam = [
    member = "user:root@terraform.landing.systems" # REQUIRED EDIT. user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com

organization_iam = [
    member       = "user:root@terraform.landing.systems" # REQUIRED EDIT. user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
  
guardrails = {
  user_defined_string = "guardrails0127tls" # Optional EDIT. Must be unique. Defines the guardrails project in form department_codeEnvironmente-owner-user_defined_string
```

#### perimeter-network.auto.tfvars
```
public_perimeter_net = {
  user_defined_string            = "tls" # REQUIRED EDIT must contribute to being globally unique
  additional_user_defined_string = "perim" # OPTIONAL EDIT check 61 char aggregate limit
     network_name                           = "tlspubpervpc" # Optional Edit
      subnet_name           = "pubtls" # Optional edit
private_perimeter_net = {
  user_defined_string            = "prd" # must be globally unique
  additional_user_defined_string = "priper" # check 61 char aggregate limit
     network_name                           = "pripervpc" #Optional Edit
           subnet_name           = "privtls"
ha_perimeter_net = {
  user_defined_string            = "prod" # must be globally unique
  additional_user_defined_string = "haper" # check 61 char agreggate limit
      network_name                           = "hapertls" # REQUIRED EDIT - example: depthaper
                subnet_name           = "hasync"
management_perimeter_net = {
  user_defined_string            = "prd" # must be globally unique
  additional_user_defined_string = "perim" # check 61 char aggregate limit
      network_name                           = "tlsmgmtper" # REQUIRED EDIT - example: deptmgmtper
                subnet_name           = "tlsmgment"
```

#### nonp-network.auto.tfvars
```
nonprod_host_net = {
  user_defined_string            = "tls" # Used to create project name - must be globally unique in aggregate
  additional_user_defined_string = "np" # check total 61 char limit with this addition
      network_name                           = "nprod-sharedvpc"
                subnet_name           = "npsubnet01"
```

#### prod-network.auto.tfvars
```
prod_host_net = {
  user_defined_string            = "tlsprod" # Must be globally unique. Used to create project name
  additional_user_defined_string = "host2"
  networks = [
      network_name                           = "prod-shvpc"
```

### Full Diff
```
diff --git a/environments/bootstrap/bootstrap.auto.tfvars b/environments/bootstrap/bootstrap.auto.tfvars
index 97d8e9a..0d34514 100644
--- a/environments/bootstrap/bootstrap.auto.tfvars
+++ b/environments/bootstrap/bootstrap.auto.tfvars
@@ -24,16 +24,16 @@
 #
 
 bootstrap = {
-  userDefinedString           = "" # REQUIRED EDIT Appended to project name/id ##needs to be lower case and min. 3 characters
-  additionalUserDefinedString = "" # OPTIONAL EDIT Additional appended string
-  billingAccount              = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Billing Account in the format of ######-######-######
+  userDefinedString           = "tls" # REQUIRED EDIT Appended to project name/id ##needs to be lower case and min. 3 characters
+  additionalUserDefinedString = "dv" # OPTIONAL EDIT Additional appended string
+  billingAccount              = "019283-6F1AB5-7AD576" # REQUIRED EDIT Billing Account in the format of ######-######-######
   # switch out root_node depending on whether you are running directly off the organization or a folder
-  #parent                      = "organizations/REPLACE_ORGANIZATION_ID" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
-  parent                      = "folders/REPLACE_FOLDER_ID" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
-  terraformDeploymentAccount  = "" # REQUIRED EDIT Name of a service account to be created (alphanumeric before the at sign) used to deploy the terraform code
-  bootstrapEmail              = "user:" # REQUIRED EDIT In the form of 'user:user@email.com
+  #parent                      = "organizations/131880894992" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
+  parent                      = "folders/1095248971440" # REQUIRED EDIT Node in format "organizations/#############" or "folders/#############"
+  terraformDeploymentAccount  = "tftlssa0127" # REQUIRED EDIT Name of a service account to be created (alphanumeric before the at sign) used to deploy the terraform code
+  bootstrapEmail              = "user:root@terraform.landing.systems" # REQUIRED EDIT In the form of 'user:user@email.com
   region                      = "northamerica-northeast1" # REQUIRED EDIT Region name. northamerica-northeast1
-  cloud_source_repo_name      = "" # REQUIRED EDIT CSR used as a mirror for code
+  cloud_source_repo_name      = "tlscsr" # REQUIRED EDIT CSR used as a mirror for code
   projectServices = [
     "cloudbilling.googleapis.com",
     "serviceusage.googleapis.com",
@@ -46,21 +46,21 @@ bootstrap = {
   ]
   tfstate_buckets = {
     common = {
-      name = "" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
+      name = "tlslzcom" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
       labels = {
       }
       storage_class = "STANDARD"
       force_destroy = true
     },
     nonprod = {
-      name = "" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
+      name = "tlslznprd" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
       labels = {
       }
       force_destroy = true
       storage_class = "STANDARD"
     },
     prod = {
-      name = "" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
+      name = "tlslzprd" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
       labels = {
       }
       force_destroy = true
@@ -70,10 +70,10 @@ bootstrap = {
 }
 # Cloud Build
 cloud_build_admins = [
-  "user:user@google.com", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
+  "user:root@terraform.landing.systems", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
 ]
 group_build_viewers = [
-  "user:user@google.com", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
+  "user:root@terraform.landing.systems", # REQUIRED EDIT user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
 ]
 
 #cloud_build_user_defined_string = ""
diff --git a/environments/bootstrap/organization-config.auto.tfvars b/environments/bootstrap/organization-config.auto.tfvars
index 3f328d2..ce99b61 100644
--- a/environments/bootstrap/organization-config.auto.tfvars
+++ b/environments/bootstrap/organization-config.auto.tfvars
@@ -17,20 +17,21 @@
 
 
 organization_config = {
-  org_id          = "REPLACE_ORGANIZATION_ID" # REQUIRED EDIT Numeric portion only '#############'"
+  org_id          = "131880894992" # REQUIRED EDIT Numeric portion only '#############'"
   default_region  = "northamerica-northeast1" # REQUIRED EDIT Cloudbuild Region - default to na-ne1 or 2
-  department_code = "" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
-  owner           = "" # REQUIRED EDIT Used in naming standard
+  department_code = "Ts" # REQUIRED EDIT Two Characters. Capitol and then lowercase 
+  owner           = "tls" # REQUIRED EDIT Used in naming standard
   environment     = "P" # REQUIRED EDIT S-Sandbox P-Production Q-Quality D-development
   location        = "northamerica-northeast1" # REQUIRED EDIT Location used for resources. Currently northamerica-northeast1 is available
   labels          = {} # REQUIRED EDIT Object used for resource labels
   # switch out root_node depending on whether you are running directly off the organization or a folder
-  #root_node       = "organizations/REPLACE_ORGANIZATION_ID" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
-  root_node       = "folders/REPLACE_FOLDER_ID" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
+  #root_node       = "organizations/131880894992" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
+  root_node       = "folders/1095248971440" # REQUIRED EDIT format "organizations/#############" or "folders/#############"
   
   contacts = {
-    "user@email.com" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
+    "root@terraform.landing.systems" = ["ALL"] # REQUIRED EDIT Essential Contacts for notifications. Must be in the form EMAIL -> [NOTIFICATION_TYPES]
   }
-  billing_account = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT Format of ######-######-######
+  # obrienlabs
+  billing_account = "019283-6F1AB5-7AD576" # REQUIRED EDIT Format of ######-######-######
 }
 
diff --git a/environments/common/common.auto.tfvars b/environments/common/common.auto.tfvars
index 959836d..ba3b17c 100644
--- a/environments/common/common.auto.tfvars
+++ b/environments/common/common.auto.tfvars
@@ -34,8 +34,8 @@ org_policies = {
 }
 folders = {
    # switch out parent depending on whether you are running directly off the organization or a folder
-  #parent = "organizations/REPLACE_ORGANIZATION_ID" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
-  parent = "folders/REPLACE_FOLDER_ID" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
+  #parent = "organizations/131880894992" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
+  parent = "folders/1095248971440" #REQUIRED Edit, format "organizations/#############" or "folders/#############"
   names  = ["Infrastructure", "Sandbox", "Workloads", "Audit and Security", "Automation", "Shared Services"] # Production, NonProduction and Platform are included in the module
   subfolders_1 = {
     SharedInfrastructure = "Infrastructure"
@@ -56,26 +56,26 @@ folders = {
 access_context_manager = { # REQUIRED OBJECT. VPC Service Controls object. 
   policy_name         = "" # OPTIONAL EDIT. If null, will be generated by module. Only used when creating new policy.
   policy_id           = "" # OPTIONAL EDIT. Only used when previously existing. Includes subsequent runs 
-  user_defined_string = "acm" # Optional EDIT.
+  user_defined_string = "tlsacm" # Optional EDIT.
   access_level        = {} # leave empty for testing
 }
 
 audit = {                                  # REQUIRED OBJECT. Must include an audit object.
   user_defined_string            = "audit" # REQUIRED EDIT. Must be globally unique, used for the audit project
-  additional_user_defined_string = ""      # OPTIONAL EDIT. Optionally append a value to the end of the user defined string.
-  billing_account                = "REPLACE_WITH_BILLING_ID"      # REQUIRED EDIT. Define the audit billing account
+  additional_user_defined_string = "tls"      # OPTIONAL EDIT. Optionally append a value to the end of the user defined string.
+  billing_account                = "019283-6F1AB5-7AD576"      # REQUIRED EDIT. Define the audit billing account
   audit_streams = {
     prod = {
-      bucket_name          = ""                     # REQUIRED EDIT. Must be globally unique, used for the audit bucket
+      bucket_name          = "audittls"                     # REQUIRED EDIT. Must be globally unique, used for the audit bucket
       is_locked            = false                  # OPTIONAL EDIT. Required value as it cannot be left null.
       bucket_force_destroy = true                   # OPTIONAL EDIT. Required value as it cannot be left null.
       bucket_storage_class = "STANDARD"             # OPTIONAL EDIT. Required value as it cannot be left null.
       labels               = {}                     # OPTIONAL EDIT. 
-      sink_name            = ""                     # REQUIRED EDIT. Must be unique across organization
+      sink_name            = "tlssink1"                     # REQUIRED EDIT. Must be unique across organization
       description          = "Org Sink"             # OPTIONAL EDIT. Required value as it cannot be left null.
       filter               = "severity >= WARNING"  # OPTIONAL EDIT. Required value as it cannot be left null.
       retention_period     = 1                      # OPTIONAL EDIT. Required value as it cannot be left null.
-      bucket_viewer        = "user:user@google.com" # REQUIRED EDIT. 
+      bucket_viewer        = "user:root@terraform.landing.systems" # REQUIRED EDIT. 
     }
   }
   audit_lables = {}
@@ -83,7 +83,7 @@ audit = {                                  # REQUIRED OBJECT. Must include an au
 
 audit_project_iam = [ #REQUIRED EDIT. At least one object is required. The member cannot be the same for multiple objects.
   {
-    member = "user:group@test.domain.net" #REQUIRED EDIT
+    member = "user:root@terraform.landing.systems" #REQUIRED EDIT
     #project = module.project.project_id  #(will be added during deployment using local var)
     roles = [
       "roles/viewer",
@@ -91,7 +91,7 @@ audit_project_iam = [ #REQUIRED EDIT. At least one object is required. The membe
     ]
   },
 /*  {
-    member = "group:group2@test.domain.net"
+    member = "group:root@terraform.landing.systems"
     roles = [
       "roles/viewer",
     ]
@@ -101,7 +101,7 @@ audit_project_iam = [ #REQUIRED EDIT. At least one object is required. The membe
 
 folder_iam = [
   {
-    member = "group:group@test.domain.net" # REQUIRED EDIT. user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
+    member = "user:root@terraform.landing.systems" # REQUIRED EDIT. user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
     #folder = module.core-folders.folders_map_1_level["Audit"].id #(will be added during deployment using local var)
     audit_folder_name = "Audit" # REQUIRED EDIT. Name of the Audit folder previously defined.
     roles = [
@@ -113,8 +113,8 @@ folder_iam = [
 
 organization_iam = [
   {
-    member       = "group:group@test.domain.net" # REQUIRED EDIT. user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
-    organization = "REPLACE_ORGANIZATION_ID" #Insert your Ord ID here, format ############
+    member       = "user:root@terraform.landing.systems" # REQUIRED EDIT. user:user@google.com, group:users@google.com,serviceAccount:robot@PROJECT.iam.gserviceaccount.com
+    organization = "131880894992" #Insert your Ord ID here, format ############
     roles = [
       "roles/viewer",
     ]
@@ -122,8 +122,8 @@ organization_iam = [
 ]
 
 guardrails = {
-  user_defined_string = "guardrails" # Optional EDIT. Must be unique. Defines the guardrails project in form department_codeEnvironmente-owner-user_defined_string
-  billing_account     = "REPLACE_WITH_BILLING_ID" # REQUIRED EDIT. Billing Account in the format of ######-######-######
+  user_defined_string = "guardrails0127tls" # Optional EDIT. Must be unique. Defines the guardrails project in form department_codeEnvironmente-owner-user_defined_string
+  billing_account     = "019283-6F1AB5-7AD576" # REQUIRED EDIT. Billing Account in the format of ######-######-######
   org_id_scan_list = [     # REQUIRED EDIT. Organization Id list for service account to have cloud asset viewer permission
   ]
   org_client = false #Set to true if deploying remote client landing zone.  Otherwise set to false if deploying for core organization landing zone.
diff --git a/environments/common/perimeter-network.auto.tfvars b/environments/common/perimeter-network.auto.tfvars
index de86abe..188553b 100644
--- a/environments/common/perimeter-network.auto.tfvars
+++ b/environments/common/perimeter-network.auto.tfvars
@@ -17,14 +17,14 @@
 
 
 public_perimeter_net = {
-  user_defined_string            = "prd" # REQUIRED EDIT must contribute to being globally unique
+  user_defined_string            = "tls" # REQUIRED EDIT must contribute to being globally unique
   additional_user_defined_string = "perim" # OPTIONAL EDIT check 61 char aggregate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   labels                         = {}
   networks = [
     {
-      network_name                           = "pubpervpc" # Optional Edit
+      network_name                           = "tlspubpervpc" # Optional Edit
       description                            = "The Public Perimeter VPC"
       routing_mode                           = "GLOBAL"
       shared_vpc_host                        = false
@@ -34,7 +34,7 @@ public_perimeter_net = {
       peer_network                           = "" # Production VPC Name
       subnets = [
         {
-          subnet_name           = "public" # Optional edit
+          subnet_name           = "pubtls" # Optional edit
           subnet_ip             = "10.10.0.0/26" # Recommended Edit
           subnet_region         = "northamerica-northeast1"
           subnet_private_access = true
@@ -53,13 +53,13 @@ public_perimeter_net = {
   ]
 }
 private_perimeter_net = {
-  user_defined_string            = "prod" # must be globally unique
+  user_defined_string            = "prd" # must be globally unique
   additional_user_defined_string = "priper" # check 61 char aggregate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   networks = [
     {
-      network_name                           = "privpervpc" #Optional Edit
+      network_name                           = "pripervpc" #Optional Edit
       description                            = "The Private Perimeter VPC"
       routing_mode                           = "GLOBAL"
       shared_vpc_host                        = false
@@ -69,7 +69,7 @@ private_perimeter_net = {
       peer_network                           = "" # Production VPC Name
       subnets = [
         {
-          subnet_name           = "private"
+          subnet_name           = "privtls"
           subnet_ip             = "10.10.0.64/26" #Recommended Edit
           subnet_region         = "northamerica-northeast1"
           subnet_private_access = true
@@ -89,13 +89,13 @@ private_perimeter_net = {
 
 ha_perimeter_net = {
   user_defined_string            = "prod" # must be globally unique
-  additional_user_defined_string = "perim" # check 61 char agreggate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  additional_user_defined_string = "haper" # check 61 char agreggate limit
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   networks = [
     {
-      network_name                           = "<ha-perimeter-vpc-name>" # REQUIRED EDIT - example: depthaper
-      description                            = "The Perimeter VPC"
+      network_name                           = "hapertls" # REQUIRED EDIT - example: depthaper
+      description                            = "The ha Perimeter VPC"
       routing_mode                           = "GLOBAL"
       shared_vpc_host                        = false
       auto_create_subnetworks                = false
@@ -124,14 +124,14 @@ ha_perimeter_net = {
 }
 
 management_perimeter_net = {
-  user_defined_string            = "prod" # must be globally unique
+  user_defined_string            = "prd" # must be globally unique
   additional_user_defined_string = "perim" # check 61 char aggregate limit
-  billing_account                = "REPLACE_WITH_BILLING_ID" #####-#####-#####
+  billing_account                = "019283-6F1AB5-7AD576" #####-#####-#####
   services                       = ["logging.googleapis.com"]
   networks = [
     {
-      network_name                           = "<management-perimeter-vpc-name>" # REQUIRED EDIT - example: deptmgmtper
-      description                            = "The Perimeter VPC"
+      network_name                           = "tlsmgmtper" # REQUIRED EDIT - example: deptmgmtper
+      description                            = "The mgmt Perimeter VPC"
       routing_mode                           = "GLOBAL"
       shared_vpc_host                        = false
       auto_create_subnetworks                = false
@@ -140,7 +140,7 @@ management_perimeter_net = {
       peer_network                           = "" # Production VPC Name
       subnets = [
         {
-          subnet_name           = "management"
+          subnet_name           = "tlsmgment"
           subnet_ip             = "10.10.0.192/26"
           subnet_region         = "northamerica-northeast1"
           subnet_private_access = true
diff --git a/environments/nonprod/nonp-network.auto.tfvars b/environments/nonprod/nonp-network.auto.tfvars
index 64c099c..7318427 100644
--- a/environments/nonprod/nonp-network.auto.tfvars
+++ b/environments/nonprod/nonp-network.auto.tfvars
@@ -17,13 +17,13 @@
 
 
 nonprod_host_net = {
-  user_defined_string            = "" # Used to create project name - must be globally unique in aggregate
-  additional_user_defined_string = "" # check total 61 char limit with this addition
-  billing_account                = "REPLACE_WITH_BILLING_ID" #"######-######-######"
+  user_defined_string            = "tls" # Used to create project name - must be globally unique in aggregate
+  additional_user_defined_string = "np" # check total 61 char limit with this addition
+  billing_account                = "019283-6F1AB5-7AD576" #"######-######-######"
   services                       = ["logging.googleapis.com" , "dns.googleapis.com"]
   networks = [
     {
-      network_name                           = "nonprod-sharedvpc"
+      network_name                           = "nprod-sharedvpc"
       description                            = "The Non-Production Shared VPC"
       routing_mode                           = "GLOBAL"
       shared_vpc_host                        = true
@@ -36,7 +36,7 @@ nonprod_host_net = {
       mtu                                    = 0
       subnets = [
         {
-          subnet_name           = "subnet01"
+          subnet_name           = "npsubnet01"
           subnet_ip             = "10.10.20.0/24"
           subnet_region         = "northamerica-northeast1"
           subnet_private_access = true
diff --git a/environments/prod/prod-network.auto.tfvars b/environments/prod/prod-network.auto.tfvars
index 5d80cb4..f33c387 100644
--- a/environments/prod/prod-network.auto.tfvars
+++ b/environments/prod/prod-network.auto.tfvars
@@ -17,13 +17,13 @@
 
 
 prod_host_net = {
-  user_defined_string            = "prod" # Must be globally unique. Used to create project name
-  additional_user_defined_string = "host1"
-  billing_account                = "REPLACE_WITH_BILLING_ID" ######-######-###### # required
+  user_defined_string            = "tlsprod" # Must be globally unique. Used to create project name
+  additional_user_defined_string = "host2"
+  billing_account                = "019283-6F1AB5-7AD576" ######-######-###### # required
   services                       = ["logging.googleapis.com"]
   networks = [
     {
-      network_name                           = "prod-sharedvpc"
+      network_name                           = "prod-shvpc"
       description                            = "The Production Shared VPC"
       routing_mode                           = "GLOBAL"
       shared_vpc_host                        = true
@@ -40,7 +40,7 @@ prod_host_net = {
           subnet_ip             = "10.10.20.0/24"
           subnet_region         = "northamerica-northeast1"
           subnet_private_access = true
-          description           = "This subnet has a description"
+          description           = "This subnet used by the shared infrastructure project"
           log_config = {
             aggregation_interval = "INTERVAL_5_SEC"
             flow_sampling        = 0.5

```

### root user IAM roles
root user has Owner, Organization Admin, FolderAdmin and (on billing only Billing Account Administrator) - I expect issues with the Terraform service account not on billing as a BAA and a missing ServiceAccountTokenCreator

<img width="794" alt="Screen Shot 2023-01-28 at 11 58 09" src="https://user-images.githubusercontent.com/24765473/215279034-038587c1-d432-4940-8fea-bd22c83350bb.png">

## Run bootstrap - create SA and CSR
20230128:1203
```
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/bootstrap (lz-tls)$ ./bootstrap.sh run
User: root@terraform.landing.systems
Domain: terraform.landing.systems
Is this is user and domain of the organization you want to deploy to? (y/n)
>  y
INFO - Applying roles to Organization Node
Updated IAM policy for organization [131880894992].
Updated IAM policy for organization [131880894992].
Updated IAM policy for organization [131880894992].
Updated IAM policy for organization [131880894992].
Updated IAM policy for organization [131880894992].
Updated IAM policy for organization [131880894992].
Updated IAM policy for organization [131880894992].
INFO - Running a plan to ensure the configuration file is correct
Initializing modules...
- cloudbuild_bootstrap in ../../modules/cloudbuild
- landing_zone_bootstrap in ../../modules/landing-zone-bootstrap
- landing_zone_bootstrap.project in ../../modules/project
- landing_zone_bootstrap.project.project_name in ../../modules/naming-standard/modules/gcp/project
- landing_zone_bootstrap.project.project_name.common_prefix in ../../modules/naming-standard/modules/common/gc_prefix
- landing_zone_bootstrap.project.project_name.name_generation in ../../modules/naming-standard/modules/common/name_generator
- landing_zone_bootstrap.project_name in ../../modules/naming-standard/modules/gcp/project
- landing_zone_bootstrap.project_name.common_prefix in ../../modules/naming-standard/modules/common/gc_prefix
- landing_zone_bootstrap.project_name.name_generation in ../../modules/naming-standard/modules/common/name_generator
- landing_zone_bootstrap.state_bucket_names in ../../modules/naming-standard/modules/gcp/storage
- landing_zone_bootstrap.state_bucket_names.common_prefix in ../../modules/naming-standard/modules/common/gc_prefix
- landing_zone_bootstrap.state_bucket_names.name_generation in ../../modules/naming-standard/modules/common/name_generator
There are some problems with the configuration, described below.

The Terraform configuration must be valid before initialization so that
Terraform can determine which modules and providers need to be installed.
╷
│ Error: Experiment has concluded
│
│   on terraform.tf line 19, in terraform:
│   19:   experiments = [module_variable_optional_attrs]
│
│ Experiment "module_variable_optional_attrs" is no longer available. The final feature corresponding to this experiment differs from the experimental form and is available in the Terraform language from Terraform
│ v1.3.0 onwards.
```

### Fix Issue with terraform

20230128 fixing via taking out the line historically for 1.3 in https://github.com/hashicorp/terraform/issues/31692 - we are using 1.3.7 and don't want to switch to 1.4.0 yet - it is still in alpha

everywhere
```

terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  required_version = ">= 1.3.0"
  #experiments = [module_variable_optional_attrs]
}

  # module.landing_zone_bootstrap.module.project.google_project_service.project_services["sourcerepo.googleapis.com"] will be created
  + resource "google_project_service" "project_services" {
      + disable_dependent_services = true
      + disable_on_destroy         = true
      + id                         = (known after apply)
      + project                    = "tspe-tls-tls-dv"
      + service                    = "sourcerepo.googleapis.com"
    }

Plan: 98 to add, 0 to change, 0 to destroy.
```
### Continue with terraform apply
1255

<img width="858" alt="Screen Shot 2023-01-28 at 12 54 34" src="https://user-images.githubusercontent.com/24765473/215283077-ed4eb0f0-b3dd-4484-86b4-65b584b4fbb5.png">

```
To perform exactly these actions, run the following command to apply:
    terraform apply "launchpad.2023-01-28.1701.plan"
Please confirm that you have reviewed the plan and wish to apply it. Type 'yes' to proceed
yes

INFO - Applying Terraform plan
module.landing_zone_bootstrap.module.project.google_project.project: Creating...
module.landing_zone_bootstrap.module.project.google_project.project: Still creating... [3m10s elapsed]
module.landing_zone_bootstrap.module.project.google_project.project: Creation complete after 3m12s [id=projects/tspe-tls-tls-dv]
module.landing_zone_bootstrap.module.project.google_project_service.project_services["iam.googleapis.com"]: Creating...
module.landing_zone_bootstrap.module.project.google_project_service.project_services["cloudbilling.googleapis.com"]: Creating...


5 min

module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_cb["prod"]: Creating...
module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam["prod"]: Creating...
module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_cb["common"]: Creating...
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/resourcemanager.organizationViewer"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/compute.networkAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/iam.organizationRoleAdmin" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/iam.organizationRoleAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/iam.serviceAccountAdmin" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/iam.serviceAccountAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/compute.xpnAdmin" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/compute.xpnAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/resourcemanager.projectDeleter" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/resourcemanager.projectDeleter"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/resourcemanager.projectCreator" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/resourcemanager.projectCreator"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/iam.serviceAccountTokenCreator"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/viewer"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/serviceusage.serviceUsageAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/storage.admin" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/storage.admin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error applying IAM policy for organization "131880894992": Error setting IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:setIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/billing.user"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/orgpolicy.policyAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/resourcemanager.folderAdmin" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/resourcemanager.folderAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/iam.securityAdmin" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/iam.securityAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/accesscontextmanager.policyAdmin" Member "serviceAccount:tftlssa0127@tspe-tls-tls-dv.iam.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/accesscontextmanager.policyAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/logging.configWriter"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/compute.admin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 39, in resource "google_organization_iam_member" "tf_sa_org_perms":
│   39: resource "google_organization_iam_member" "tf_sa_org_perms" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/viewer" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/viewer"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/resourcemanager.projectCreator" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/resourcemanager.projectCreator"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/serviceusage.serviceUsageAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/serviceusage.serviceUsageAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/compute.networkAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/compute.networkAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/iam.organizationRoleAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/iam.organizationRoleAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/iam.securityAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/iam.securityAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/compute.xpnAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/compute.xpnAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/storage.admin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/storage.admin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/orgpolicy.policyAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/orgpolicy.policyAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/iam.serviceAccountTokenCreator" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/iam.serviceAccountTokenCreator"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/accesscontextmanager.policyAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/accesscontextmanager.policyAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/billing.user" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/billing.user"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/iam.serviceAccountAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/iam.serviceAccountAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/logging.configWriter" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/logging.configWriter"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/resourcemanager.folderAdmin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/resourcemanager.folderAdmin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/resourcemanager.organizationViewer" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/resourcemanager.organizationViewer"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error when reading or editing Resource "organization \"131880894992\"" with IAM Member: Role "roles/compute.admin" Member "serviceAccount:190340082528@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for organization "131880894992": Post "https://cloudresourcemanager.googleapis.com/v1/organizations/131880894992:getIamPolicy?alt=json&prettyPrint=false": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms_cb["roles/compute.admin"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 49, in resource "google_organization_iam_member" "tf_sa_org_perms_cb":
│   49: resource "google_organization_iam_member" "tf_sa_org_perms_cb" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslzcom": Get "https://storage.googleapis.com/storage/v1/b/tspetlslzcom/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam["common"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 106, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam":
│  106: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslzprd": Get "https://storage.googleapis.com/storage/v1/b/tspetlslzprd/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam["prod"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 106, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam":
│  106: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslznprd": Get "https://storage.googleapis.com/storage/v1/b/tspetlslznprd/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam["nonprod"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 106, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam":
│  106: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslznprd": Get "https://storage.googleapis.com/storage/v1/b/tspetlslznprd/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_cb["nonprod"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 112, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_cb":
│  112: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_cb" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslzcom": Get "https://storage.googleapis.com/storage/v1/b/tspetlslzcom/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_cb["common"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 112, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_cb":
│  112: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_cb" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslzprd": Get "https://storage.googleapis.com/storage/v1/b/tspetlslzprd/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_cb["prod"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 112, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_cb":
│  112: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_cb" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslzprd": Get "https://storage.googleapis.com/storage/v1/b/tspetlslzprd/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_bootstrap_email["prod"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 120, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_bootstrap_email":
│  120: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_bootstrap_email" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslzcom": Get "https://storage.googleapis.com/storage/v1/b/tspetlslzcom/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_bootstrap_email["common"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 120, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_bootstrap_email":
│  120: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_bootstrap_email" {
│
╵
╷
│ Error: Error retrieving IAM policy for storage bucket "b/tspetlslznprd": Get "https://storage.googleapis.com/storage/v1/b/tspetlslznprd/iam?alt=json&optionsRequestedPolicyVersion=3": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_storage_bucket_iam_member.common_org_terraform_state_iam_bootstrap_email["nonprod"],
│   on ../../modules/landing-zone-bootstrap/main.tf line 120, in resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_bootstrap_email":
│  120: resource "google_storage_bucket_iam_member" "common_org_terraform_state_iam_bootstrap_email" {
│
╵
╷
│ Error: Error retrieving IAM policy for sourcerepo repository "projects/tspe-tls-tls-dv/repos/tlscsr": Get "https://sourcerepo.googleapis.com/v1/projects/tspe-tls-tls-dv/repos/tlscsr:getIamPolicy?alt=json": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_sourcerepo_repository_iam_member.sa_member,
│   on ../../modules/landing-zone-bootstrap/main.tf line 134, in resource "google_sourcerepo_repository_iam_member" "sa_member":
│  134:   resource "google_sourcerepo_repository_iam_member" "sa_member" {
│
╵
╷
│ Error: Error retrieving IAM policy for sourcerepo repository "projects/tspe-tls-tls-dv/repos/tlscsr": Get "https://sourcerepo.googleapis.com/v1/projects/tspe-tls-tls-dv/repos/tlscsr:getIamPolicy?alt=json": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_sourcerepo_repository_iam_member.sa_member_cb,
│   on ../../modules/landing-zone-bootstrap/main.tf line 141, in resource "google_sourcerepo_repository_iam_member" "sa_member_cb":
│  141:   resource "google_sourcerepo_repository_iam_member" "sa_member_cb" {
│
╵
╷
│ Error: Error retrieving IAM policy for sourcerepo repository "projects/tspe-tls-tls-dv/repos/tlscsr": Get "https://sourcerepo.googleapis.com/v1/projects/tspe-tls-tls-dv/repos/tlscsr:getIamPolicy?alt=json": oauth2/google: incomplete token received from metadata
│
│   with module.landing_zone_bootstrap.google_sourcerepo_repository_iam_member.iam_member,
│   on ../../modules/landing-zone-bootstrap/main.tf line 149, in resource "google_sourcerepo_repository_iam_member" "iam_member":
│  149: resource "google_sourcerepo_repository_iam_member" "iam_member" {
│
```

## Adding roles
- already appended to roles
<img width="1217" alt="Screen Shot 2023-01-28 at 13 03 48" src="https://user-images.githubusercontent.com/24765473/215283477-af5b6638-9e43-4886-933a-8d340a6215a5.png">


- expected to add SATK
<img width="557" alt="Screen Shot 2023-01-28 at 13 03 20" src="https://user-images.githubusercontent.com/24765473/215283462-cdd1f61c-df22-4b60-881d-f0c63b928005.png">

## Rerun terraform apply
```
Plan: 73 to add, 1 to change, 26 to destroy.

TF_SA deleted/recreated
module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/billing.user"]: Still creating... [50s elapsed]
module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/compute.admin"]: Still creating... [50s elapsed]
module.landing_zone_bootstrap.google_organization_iam_member.tf_sa_org_perms["roles/serviceusage.serviceUsageAdmin"]: Still creating... [50s elapsed]
```
<img width="1724" alt="Screen Shot 2023-01-28 at 13 10 21" src="https://user-images.githubusercontent.com/24765473/215283772-7ceeb744-afa2-448b-8121-37e23b4616ed.png">

```
odule.cloudbuild_bootstrap.google_cloudbuild_trigger.push_request_trigger["landing-zone-nonprod"]: Creation complete after 0s [id=projects/tspe-tls-tls-dv/triggers/724081f7-3a15-4e4e-b358-f2f8d39669cb]
module.cloudbuild_bootstrap.google_cloudbuild_trigger.push_request_trigger["landing-zone-prod"]: Creation complete after 0s [id=projects/tspe-tls-tls-dv/triggers/f380c1c7-fe4d-4b3a-8f58-06f074a8e065]

 [1 files][203.2 KiB/203.2 KiB]
Operation completed over 1 objects/203.2 KiB.
Terraform default.tfstate exists.
INFO - Create bootstrap backend
INFO - Create common backend
INFO - Create bootstrap provider
INFO - Create common provider
INFO - Create nonprod backend and provider
INFO - Create prod backend and provider
INFO - Committing code to CSR
Specify your git config email
michael@obrienlabs.org
Specify your git config name
michaelobrien

```
<img width="435" alt="Screen Shot 2023-01-28 at 13 11 44" src="https://user-images.githubusercontent.com/24765473/215283819-be7fa31b-b492-4372-a8ba-dfee866557da.png">

```
INFO - CSR is not a remote, adding it
INFO - Pushing code to CSR
Enumerating objects: 653, done.
Counting objects: 100% (653/653), done.
Delta compression using up to 4 threads
Compressing objects: 100% (635/635), done.
Writing objects: 100% (653/653), 25.26 MiB | 15.56 MiB/s, done.
Total 653 (delta 277), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (277/277)
To https://source.developers.google.com/p/tspe-tls-tls-dv/r/tlscsr
 * [new branch]      main -> main
INFO - Code pushed to CSR
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding/environments/bootstrap (lz-tls)$
```

looks ok - checking cloud build and CSR
<img width="1715" alt="Screen Shot 2023-01-28 at 13 19 55" src="https://user-images.githubusercontent.com/24765473/215284162-7720e2d1-351e-4ddd-b515-6579e7855b42.png">

#### Billing Account User Role for Terraform Service Account
<img width="1719" alt="Screen Shot 2023-01-28 at 16 30 55" src="https://user-images.githubusercontent.com/24765473/215292081-fe5be81f-2438-41ab-8a19-ae46f84abf45.png">

#### Staging Project
<img width="1210" alt="Screen Shot 2023-01-28 at 16 30 14" src="https://user-images.githubusercontent.com/24765473/215292061-361ee11d-772d-48c9-a6a0-fe22fa13db5f.png">

<img width="1720" alt="Screen Shot 2023-01-28 at 16 32 22" src="https://user-images.githubusercontent.com/24765473/215292130-dba4c282-4f64-4d74-84f2-3143d73bf53d.png">

#### Cloud Storage
<img width="1415" alt="Screen Shot 2023-01-28 at 16 29 09" src="https://user-images.githubusercontent.com/24765473/215292022-519fb288-1e25-4803-9455-415ba7e3c996.png">

#### Resource Manager
<img width="730" alt="Screen Shot 2023-01-28 at 13 14 46" src="https://user-images.githubusercontent.com/24765473/215283930-9b634d4e-df65-4743-9cd0-5508c746aa96.png">

#### GitOps: Artifact Registry Container
<img width="1718" alt="Screen Shot 2023-01-28 at 16 34 18" src="https://user-images.githubusercontent.com/24765473/215292187-ad49468e-8041-445a-97d3-f1f45a975a52.png">

#### Cloud Source Repository

https://source.cloud.google.com/tspe-tls-tls-dv/tlscsr/+/main:

#### Cloud Build
Failed builds are normal - we will rerun them in sequence - bootstrap and common first

using image
```
northamerica-northeast1-docker.pkg.dev/tspe-tls-tls-dv/tls-tf-runners/terraform
```

<img width="1413" alt="Screen Shot 2023-01-28 at 13 15 36" src="https://user-images.githubusercontent.com/24765473/215283967-4fed0954-c00f-4152-9ddd-b63375c4f261.png">

#### Cloud Source Repositories
<img width="1714" alt="Screen Shot 2023-01-28 at 13 16 25" src="https://user-images.githubusercontent.com/24765473/215283998-56f1edd4-03c9-4883-af5e-750a12e2699c.png">

### Rerun Cloud Build Triggers in Sequence
#### Bootstrap
<img width="1719" alt="Screen Shot 2023-01-28 at 16 26 56" src="https://user-images.githubusercontent.com/24765473/215291962-35d1a9b0-d745-470b-a700-0c981db1c131.png">

<img width="665" alt="Screen Shot 2023-01-28 at 16 28 22" src="https://user-images.githubusercontent.com/24765473/215291999-bcd2a4e2-6d07-4c0b-8d85-6a6c4e6f5972.png">

We will need to fix the 1.0 version code in the repository
```
Step #0 - "tf init": │ Error: Unsupported Terraform Core version
Step #0 - "tf init": │ 
Step #0 - "tf init": │   on terraform.tf line 19, in terraform:
Step #0 - "tf init": │   19:   required_version = ">= 1.3.0"
Step #0 - "tf init": │ 
Step #0 - "tf init": │ This configuration does not support Terraform version 1.0.10. To proceed,
Step #0 - "tf init": │ either choose another supported Terraform version or update this version
Step #0 - "tf init": │ constraint. Version constraints are normally set for good reason, so
Step #0 - "tf init": │ updating the constraint may lead to other errors or unexpected behavior.
```

<img width="1711" alt="Screen Shot 2023-01-28 at 16 35 40" src="https://user-images.githubusercontent.com/24765473/215292229-1996afe2-f016-4379-9889-c484d956616b.png">

#### Comment out 1.3.0 version blocks

```
        modified:   environments/bootstrap/terraform.tf
        modified:   environments/common/terraform.tf
        modified:   environments/nonprod/terraform.tf
        modified:   modules/audit-bunker/variables.tf
        modified:   modules/iam/terraform.tf
        modified:   modules/landing-zone-bootstrap/terraform.tf
        modified:   modules/landing-zone-bootstrap/variables.tf
        modified:   modules/network-host-project/modules/network/variables.tf
        modified:   modules/network-host-project/modules/router/variables.tf
        modified:   modules/network-host-project/modules/subnets/variables.tf
        modified:   modules/network-host-project/modules/vpn/variables.tf
        modified:   modules/network/modules/network/variables.tf
        modified:   modules/network/modules/subnets/variables.tf
        modified:   modules/network/modules/vpn/variables.tf
        modified:   modules/virtual-machine/terraform.tf
        modified:   modules/vpc-service-controls/terraform.tf

terraform {
  #required_version = ">= 1.3.0"
  #experiments = [module_variable_optional_attrs]
}

root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding (lz-tls)$ git commit -m "remove 1.3.0 version - for exp"
[main 1c22baf] remove 1.3.0 version - for exp
 16 files changed, 16 insertions(+), 16 deletions(-)
root_@cloudshell:~/lz-tls/pbmm-on-gcp-onboarding (lz-tls)$ git push csr main
Enumerating objects: 57, done.
Counting objects: 100% (57/57), done.
Delta compression using up to 4 threads
Compressing objects: 100% (32/32), done.
Writing objects: 100% (32/32), 3.63 KiB | 743.00 KiB/s, done.
Total 32 (delta 29), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (29/29)
To https://source.developers.google.com/p/tspe-tls-tls-dv/r/tlscsr
   17b3591..1c22baf  main -> main
```
checking https://source.cloud.google.com/tspe-tls-tls-dv/tlscsr/+/main:

#### Rebuild Bootstrap
We need to remove experimental code from the repo
https://console.cloud.google.com/cloud-build/builds;region=global/f5967779-6750-4065-9c3d-44f3ee166fe4?project=tspe-tls-tls-dv&supportedpurview=project

```
Step #0 - "tf init": │ Error: Optional object type attributes are experimental
Step #0 - "tf init": │ 
Step #0 - "tf init": │   on variables.tf line 20:
Step #0 - "tf init": │   20: variable "bootstrap" {
Step #0 - "tf init": │ 
Step #0 - "tf init": │ This feature is currently an opt-in experiment, subject to change in future
Step #0 - "tf init": │ releases based on feedback.
Step #0 - "tf init": │ 
Step #0 - "tf init": │ Activate the feature for this module by adding
Step #0 - "tf init": │ module_variable_optional_attrs to the list of active experiments.
Step #0 - "tf init": ╵
Step #0 - "tf init": 
Step #0 - "tf init": ╷
Step #0 - "tf init": │ Error: Optional object type attributes are experimental
Step #0 - "tf init": │ 
Step #0 - "tf init": │   on variables.tf line 101:
Step #0 - "tf init": │  101: variable "sa_create_assign" {
Step #0 - "tf init": │ 
Step #0 - "tf init": │ This feature is currently an opt-in experiment, subject to change in future
Step #0 - "tf init": │ releases based on feedback.
Step #0 - "tf init": │ 
Step #0 - "tf init": │ Activate the feature for this module by adding
Step #0 - "tf init": │ module_variable_optional_attrs to the list of active experiments.
```

Comment sa_create_assign - as it is not used in bootstrap.auto.tfvars

https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/environments/bootstrap/variables.tf#L101

for

https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding/blob/main/environments/bootstrap/bootstrap.auto.tfvars#L150

<img width="1724" alt="Screen Shot 2023-01-28 at 16 50 40" src="https://user-images.githubusercontent.com/24765473/215292680-6ad006a0-8b1c-4aca-9255-9520c469249e.png">

```
variable "sa_create_assign" {
  description = "List of service accounts to create and roles to assign to them"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
    project      = optional(string)
  }))
  default = []
}

and


--- a/environments/bootstrap/bootstrap.auto.tfvars
+++ b/environments/bootstrap/bootstrap.auto.tfvars
@@ -47,22 +47,22 @@ bootstrap = {
   tfstate_buckets = {
     common = {
       name = "tlslzcom" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
-      labels = {
-      }
+      #labels = {
+      #}
       storage_class = "STANDARD"
       force_destroy = true
     },
     nonprod = {
       name = "tlslznprd" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
-      labels = {
-      }
+      #labels = {
+      #}
       force_destroy = true
       storage_class = "STANDARD"
     },
     prod = {
       name = "tlslzprd" # REQUIRED EDIT Must be globally unique, lower case letters and numbers only
-      labels = {
-      }
+      #labels = {
+      #}
       force_destroy = true
       storage_class = "STANDARD"
     }
diff --git a/environments/bootstrap/variables.tf b/environments/bootstrap/variables.tf
index 205cfdb..ae99af9 100644
--- a/environments/bootstrap/variables.tf
+++ b/environments/bootstrap/variables.tf
@@ -34,19 +34,19 @@ variable "bootstrap" {
       common = object(
         {
           name          = string
-          labels        = optional(map(string)),
+          #labels        = optional(map(string)),
           storage_class = string
           force_destroy = bool
       })
       nonprod = object({
         name          = string
-        labels        = optional(map(string)),
+        #labels        = optional(map(string)),
         storage_class = string
         force_destroy = bool
       })
       prod = object({
         name          = string
-        labels        = optional(map(string)),
+        #labels        = optional(map(string)),
         storage_class = string
         force_destroy = bool
       })
@@ -97,8 +97,8 @@ variable "sa_impersonation_grants" {
     impersonator = ""
   }]
 }
-
-variable "sa_create_assign" {
+# experimental optional use removed
+/*variable "sa_create_assign" {
   description = "List of service accounts to create and roles to assign to them"
   type = list(object({
     account_id   = string
@@ -107,8 +107,7 @@ variable "sa_create_assign" {
     project      = optional(string)
   }))
   default = []
-}
-
+} */

 variable "organization_config" {
   type = object({

```

fix modules part 2
```
Step #0 - "tf init": │ Error: Optional object type attributes are experimental
Step #0 - "tf init": │ 
Step #0 - "tf init": │   on ../../modules/landing-zone-bootstrap/variables.tf line 27:
Step #0 - "tf init": │   27: variable labels {
Step #0 - "tf init": │ 
Step #0 - "tf init": │ This feature is currently an opt-in experiment, subject to change in future
Step #0 - "tf init": │ releases based on feedback.
Step #0 - "tf init": │ 
Step #0 - "tf init": │ Activate the feature for this module by adding
Step #0 - "tf init": │ module_variable_optional_attrs to the list of active experiments.
Step #0 - "tf init": ╵
Step #0 - "tf init": 
Step #0 - "tf init": ╷
Step #0 - "tf init": │ Error: Optional object type attributes are experimental
Step #0 - "tf init": │ 
Step #0 - "tf init": │   on ../../modules/landing-zone-bootstrap/variables.tf line 93:
Step #0 - "tf init": │   93: variable "tfstate_buckets" {
Step #0 - "tf init": │ 
Step #0 - "tf init": │ This feature is currently an opt-in experiment, subject to change in future
Step #0 - "tf init": │ releases based on feedback.
Step #0 - "tf init": │ 
Step #0 - "tf init": │ Activate the feature for this module by adding
Step #0 - "tf init": │ module_variable_optional_attrs to the list of active experiments.


change
variable labels {
  type = object({
      creator                = string, #optional(string),
      date_created           = string, #optional(string),
      date_modified          = string, #optional(string),
      title                  = string, #optional(string),
      department             = string, #optional(string),
      imt_sector             = string, #optional(string),
      environment            = string, #optional(string),
      service_id             = string, #optional(string),
      application_name       = string, #optional(string),
      business_contact       = string, #optional(string),
      technical_contact      = string, #optional(string),
      general_ledger_account = string, #optional(string),
      cost_center            = string, #optional(string),
      internal_order         = string, #optional(string),
      sos_id                 = string, #optional(string),
      stra_id                = string, #optional(string),
      security_classification= string, #optional(string),
      criticality            = string, #optional(string),
      hours_of_operation     = string, #optional(string),
      project_code           = string, #optional(string)
  })
}

variable "tfstate_buckets" {
  type = map(
    object({
      name          = string,
      #labels        = optional(map(string)),
      force_destroy = bool, #optional(bool),
      storage_class = string, #optional(string),
    })
  )
  description = "Map of buckets to store Terraform state files"
}
```
https://console.cloud.google.com/cloud-build/builds;region=global/dc571942-4db2-4989-a871-d0ff900337bc;step=0?project=tspe-tls-tls-dv&supportedpurview=project
```
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
```

Validation needs a fix - we need an actual label string set

```
*************** TERRAFORM VALIDATE ******************
******* At environment: environments/bootstrap *************
*************************************************
╷
│ Error: Invalid value for module argument
│ 
│   on main.tf line 32, in module "landing_zone_bootstrap":
│   32:   labels                         = var.organization_config.labels
│ 
│ The given value is not suitable for child module variable "labels" defined
│ at ../../modules/landing-zone-bootstrap/variables.tf:27,1-16: attributes
│ "application_name", "business_contact", "cost_center", "creator",
│ "criticality", "date_created", "date_modified", "department",
│ "environment", "general_ledger_account", "hours_of_operation",
│ "imt_sector", "internal_order", "project_code", "security_classification",
│ "service_id", "sos_id", "stra_id", "technical_contact", and "title" are
│ required.
```

<img width="1722" alt="Screen Shot 2023-01-28 at 17 04 41" src="https://user-images.githubusercontent.com/24765473/215293118-3f1107c1-51bc-4c05-9571-d769ebf3e6de.png">




#### Common
#### non-prod
#### prod
