ls -la
rm -rf -- !(env.tar.gz)
ls -la
tar -zxf env.tar.gz
ls -la
rm -f env.tar.gz
ls -la

# Set base directory 
base_dir=$(pwd)

cd $base_dir/3-networks-hub-and-spoke

#copy the wrapper script and set read,write,execute permissions
cp ../build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

#get organization_id
export ORGANIZATION_ID=$(terraform -chdir="../0-bootstrap/" output -json common_config | jq '.org_id' --raw-output)

# Retrieve AACCESS_CONTEXT_MANAGER_ID Policy ID
export ACCESS_CONTEXT_MANAGER_ID=$(gcloud access-context-manager policies list --organization ${ORGANIZATION_ID} --format="value(name)")
echo "access_context_manager_policy_id = ${ACCESS_CONTEXT_MANAGER_ID}"

#update access_context.auto.tfvars
sed -i'' -e "s/ACCESS_CONTEXT_MANAGER_ID/${ACCESS_CONTEXT_MANAGER_ID}/" ./access_context.auto.tfvars

# Retrieve Terraform Remote State Bucket Name:
export backend_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)
echo "remote_state_bucket = ${backend_bucket}"

#Update common.auto.tfvars
sed -i'' -e "s/REMOTE_STATE_BUCKET/${backend_bucket}/" ./common.auto.tfvars

#setting google impersonate service account
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw networks_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

cat ./common.auto.tfvars

./tf-wrapper.sh init shared
./tf-wrapper.sh plan shared
./tf-wrapper.sh validate shared $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply shared

# While loop to be added for contionus apply
./tf-wrapper.sh init production
./tf-wrapper.sh plan production
./tf-wrapper.sh validate production $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
./tf-wrapper.sh apply production

MAX_RETRIES=3  # Adjust as needed
attempts=0
while [[ $attempts -lt $MAX_RETRIES ]]; do
  # Run all tf-wrapper commands
  ./tf-wrapper.sh init nonproduction
  ./tf-wrapper.sh plan nonproduction
  ./tf-wrapper.sh validate nonproduction $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
  ./tf-wrapper.sh apply nonproduction

  # Check if any command failed (check exit code of last command)
  if [[ $? -ne 0 ]]; then
    echo "Error: Some tf-wrapper commands failed. Retrying..."
    ((attempts++))
  else
    echo "3-networks  nonproduction commands applied successfully!"
    break  # Exit the loop on success
  fi
done

while [[ $attempts -lt $MAX_RETRIES ]]; do
  ./tf-wrapper.sh init development
  ./tf-wrapper.sh plan development
  ./tf-wrapper.sh validate development $(pwd)/../policy-library ${CLOUD_BUILD_PROJECT_ID}
  ./tf-wrapper.sh apply development

  if [[ $? -ne 0 ]]; then
    echo "Error: 3-network Development commands failed. Retrying..."
    ((attempts++))
  else
    echo "All tf-wrapper nonproduction commands applied successfully!"
    break  # Exit the loop on success
  fi
done

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
tar -zcf env.tar.gz --exclude env.tar.gz . 
ls -la
pwd
