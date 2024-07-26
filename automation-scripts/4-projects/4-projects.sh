#!/bin/bash


ls -la
rm -rf -- $(ls | grep -v env.tar.gz)
ls -la
tar -zxf env.tar.gz
ls -la
rm -f env.tar.gz
# Set base directory 
base_dir=$(pwd)

cd $base_dir/4-projects

ls -la
#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

ls -la ./business_units/development/
ls -la ./business_units/nonproduction/
ls -la ./business_units/production/

#Retrieve Terraform Remote State Bucket Name
export remote_state_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${remote_state_bucket}"

#Update common.auto.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${remote_state_bucket}/" ./common.auto.tfvars

#Setting the Variable
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw projects_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}



#Terraform init,plan,validate,apply for development env
# sleep 120s
cat ./common.auto.tfvars
cat ./business_units/development/common.auto.tfvars
cat ./business_units/development/development.auto.tfvars
cat ./business_units/nonproduction/common.auto.tfvars
cat ./business_units/nonproduction/nonproduction.auto.tfvars
cat ./business_units/production/common.auto.tfvars
cat ./business_units/production/production.auto.tfvars

./tf-wrapper.sh init shared
./tf-wrapper.sh plan shared
./tf-wrapper.sh validate shared $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply shared

# Run all tf-wrapper commands
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production

#Terraform init,plan,validate,apply for nonproduction env
./tf-wrapper.sh init nonproduction
./tf-wrapper.sh plan nonproduction
./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply nonproduction

MAX_RETRIES=3  # Adjust as needed
attempts=0

while [[ $attempts -lt $MAX_RETRIES ]]; do
  ./tf-wrapper.sh init development
  ./tf-wrapper.sh plan development
  ./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
  ./tf-wrapper.sh apply development

  if [[ $? -ne 0 ]]; then
    echo "Error: 4-projects development commands failed. Retrying..."
    ((attempts++))
  else
    echo "All tf-wrapper development commands applied successfully!"
    break  # Exit the loop on success
  fi
done

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
tar -zcf env.tar.gz --exclude env.tar.gz . 
ls -la
pwd