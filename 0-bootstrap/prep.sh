#!/bin/bash

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -e
action=$1
base_dir=.
builders_dir=${base_dir}/builders

do_prep_cb() {
  b_base=${builders_dir}/cb
  BE=${b_base}/backend.tf
  TF=${b_base}/cb.tf
  DF=${b_base}/Dockerfile
  OF=${b_base}/outputs.tf
  VF=${b_base}/terraform.cb.tfvars
}

do_prep_github() {
  b_base=${builders_dir}/github
  BE=${b_base}/backend.tf
  TF=${b_base}/github.tf
  OF=${b_base}/outputs.tf
  VF=${b_base}/terraform.github.tfvars
}

do_prep_gitlab() {
  b_base=${builders_dir}/gitlab
  BE=${b_base}/backend.tf
  TF=${b_base}/gitlab.tf
  OF=${b_base}/outputs.tf
  VF=${b_base}/terraform.gitlab.tfvars
}

do_prep_jenkins() {
  b_base=${builders_dir}/jenkins
  BE=${b_base}/backend.tf
  TF=${b_base}/jenkins.tf
  OF=${b_base}/outputs.tf
  VF=${b_base}/terraform.jenkins.tfvars
}

do_prep_tf_cloud() {
  b_base=${builders_dir}/tf.cloud
  BE=${b_base}/backend.tf
  TF=${b_base}/terraform_cloud.tf
  OF=${b_base}/outputs.tf
  VF=${b_base}/terraform.tf_cloud.tfvars
}

do_prep_tf_local() {
  b_base=${builders_dir}/tf.local
  BE=${b_base}/backend.tf
  TF=${b_base}/terraform_local.tf
  OF=${b_base}/outputs.tf
  VF=${b_base}/terraform.local.tfvars
}


case "$action" in
  cloudbuild )
    do_prep_cb
    ;;
  github )
    do_prep_github
    ;;
  gitlab )
    do_prep_gitlab
    ;;
  jenkins )
    do_prep_jenkins
    ;;
  tf_cloud )
    do_prep_tf_cloud
    ;;
  tf_local )
    do_prep_tf_local
    ;;
  * )
    echo "unknown option: ${1}"
    exit 99
    ;;
esac
if [ ! -z "${DF}" ]; then
   ln -s "${DF}" Dockerfile
fi
ln -s  "${BE}" backend.tf_to_rename_after_apply
ln -s  "${OF}" outputs.tf
ln -s  "${TF}" terraform.tf
ln -s  "${VF}" terraform.tfvars
echo "rename created symlink backend.tf to backend.tf_ before running terraform init"
echo "after running terraform apply rename it back to backend.tf"
