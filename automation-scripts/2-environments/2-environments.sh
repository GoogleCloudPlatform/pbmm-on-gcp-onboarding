
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

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw environment_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

cat ./terraform.tfvars
cat ./envs/development/backend.tf
echo "Checking Bootstrap Output"
cd ../0-bootstrap/ && terraform output
echo "Checking 1-Org Output"
cd ../1-org/envs/shared && terraform output
pwd
cd $base_dir/2-environments
pwd
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

