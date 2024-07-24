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
  echo "Usage: $0 clean|prep "
}

# Make sure we have two fortigate license files
check_license() {
  ls *.lic  
  if [ ! -e "./license1.lic" -o ! -e "./license2.lic" ]; then
    here=$(basename $PWD)
    echo "Symlink Fortigate license files named license1.lic and license2.lic to the $here directory"
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
  if [ "$?" -ne 0 ]; then 
    echo "update_state_bucket.sh exited with $? status"
    exit 1
  fi
}

# prework necessary before executing tf
prep(){
  activate_shell_scripts
  update_state_bucket
  check_license
}

remove_symlinks () {
  symlinks=$(find ./shared -type l)
  for s in $symlinks; do
    rm $s
  done
}

clean () {
  # Generated links
  remove_symlinks
  # Generated file
  rm ./shared/backend.tf
}

# Requre one arguments
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
