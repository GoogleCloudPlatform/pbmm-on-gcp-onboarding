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


