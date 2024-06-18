#!/bin/sh
################################################################################
# update_state_bucket.sh
# Get the name of the Terraform state bucket configured in the bootstrap phase.
# Use that bucket to store any newly created state.
# Run only from the 6-Fortigate directory, as a relative path is used.
################################################################################
#  Copyright 2021 Google LLC
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#################################################################################

mod_vars_file="./shared/shared.auto.mod.tfvars"
auto_vars_file="./shared/shared.auto.tfvars"

if [ -e "$auto_vars_file" ]; then
  echo "It looks like this has already been run. Check the contents of ./shared/*.tfvars to confirm"
  exit 0
fi

# Get the name of the state bucket
remote_state_bucket=$(terraform -chdir="../0-bootstrap/" output -raw gcs_bucket_tfstate)

if [ -n "$remote_state_bucket" ]; then 
  echo "$0 was unable to acquire the remote state bucket from ../0-bootstrap. Exiting ..."
  exit 1
fi 

cp $mod_vars_file $auto_vars_file

sed -i'' -e "s/REMOTE_STATE_BUCKET/${remote_state_bucket}/" $auto_vars_file

# Copy the backend template to backend.tf
for backend in `find . -name backend.tpl -print`; do
  dir=$(dirname $backend)
  tfname="$dir/backend.tf"
  cp $backend $tfname
done

# Add the actual bucket name
for backend in `find . -name backend.tf -print`; do
  sed -i'' -e "s/REMOTE_STATE_BUCKET/${remote_state_bucket}/" $backend
done

exit 0
