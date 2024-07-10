
# Set base directory 
base_dir=$(pwd)

cd $base_dir/2-environments

# ln -s terraform.mod.tfvars terraform.tfvars

#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

ls 

# Retrieve Actual Bucket Name
export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./development/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./nonproduction/terraform.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./production/terraform.tfvars
cat ./development/terraform.tfvars
cat ./nonproduction/terraform.tfvars
cat ./production/terraform.tfvars
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw environment_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

#Terraform init,plan,validate,apply for development env
./tf-wrapper.sh init development
./tf-wrapper.sh plan development
./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply development

#Terraform init,plan,validate,apply for nonproduction env
./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply nonproduction

#Terraform init,plan,validate,apply for production env
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production


unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
pwd

