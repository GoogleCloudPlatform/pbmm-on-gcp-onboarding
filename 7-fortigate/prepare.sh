#!/bin/sh
################################################################################
# prepare.sh Prepare Terraform for a  Fortigate installation in in either 
# development, production, or nonproduction environments.
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
################################################################################

# Like it looks
usage() {
  echo "Usage: $0 clean|prep"
}

# Make sure we have two fortigate license files
check_license() {
  if [ ! -e "./license1.lic" -o ! -e "./license2.lic" ]; then
  #if [ ! -e "./license1.lic" ]; then
    echo "Add/symlink Fortigate license files named license1.lic and license2.lic to this directory"
    exit 1
  fi
}

# make scripts executable
activate_shell_scripts() {
  find . -name "*.sh" -exec chmod 755 {} \;
}

# get the landing zone terraform state bucket
update_state_bucket() {
  /bin/sh ./helpers/update_state_bucket.sh
}

# prework necessary before executing tf
prep(){
  activate_shell_scripts
  update_state_bucket
  check_license
  link_environment development
  link_environment production
  link_environment nonproduction
}

# symlink common elements into the targeted environment folder
link_environment() {
  environment=$1

  if [ -z "$environment" ]; then 
    echo "environment unset"
    exit 1
  fi

  if [ ! -d "./$environment" ]; then
    echo "environment does not exist"
  fi

  for item in ./shared/*; do
    fname=$(basename $item)
    if [ ! -e "./$environment/$fname" ]; then
      ln -s "../shared/$fname" "./$environment/$fname"
    fi
  done

}

remove_symlinks () {
  symlinks=$(find . -type l)
  for s in $symlinks; do
    rm -i $s
  done
}

clean () {
  # A generated file from shared.auto.mod.tfvars

  if [ -e ./shared/shared.auto.tfvars ]; then
    rm -i ./shared/shared.auto.tfvars
  fi

  cd ./development 
  remove_symlinks
  cd ..

  cd ./production 
  remove_symlinks
  cd ..

  cd ./nonproduction 
  remove_symlinks
  cd ..
}

# Expect one arguments
if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

# only process valid input
case "$1" in
  clean)
    clean
    ;;
  prep)
    prep
    ;;
  *)
    usage
    exit 1
    ;;
esac

echo "$0 has run successfully"
exit 0
