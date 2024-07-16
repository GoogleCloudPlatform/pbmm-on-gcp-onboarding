ls -la
rm -rf -- $(ls | grep -v env.tar.gz)
ls -la
tar -zxf env.tar.gz
ls -la
rm -f env.tar.gz

base_dir=$(pwd)
cd $base_dir/7-fortigate

ls

ls ./shared

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$(terraform -chdir="../0-bootstrap/" output -raw organization_step_terraform_service_account_email)
echo ${GOOGLE_IMPERSONATE_SERVICE_ACCOUNT}

chmod 755 ./prepare.sh
./prepare.sh clean
./prepare.sh prep development

cd ./development

ls
terraform init

# Run Terraform plan and apply
terraform plan -input=false -out fortigate.tfplan

terraform apply fortigate.tfplan

unset GOOGLE_IMPERSONATE_SERVICE_ACCOUNT

cd ..
tar -zcf env.tar.gz --exclude env.tar.gz . 
ls -la
pwd
