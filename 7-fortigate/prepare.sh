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
  echo "Usage: $0 clean|prep [development|production|nonproduction]"
}

# Make sure we have two fortigate license files
check_license() {
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
}

# prework necessary before executing tf
prep(){
  activate_shell_scripts
  update_state_bucket

  if [ -z "$1" ]; then
    link_environment development
    link_environment production
    link_environment nonproduction
  else
    link_environment "$1"
  fi
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

  cd ./${environment} && check_license && cd ..

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
    rm $s
  done
}

clean () {

  if [ -z "$1" ]; then
    for e in development production nonproduction
    do
      cd ./$e 
      remove_symlinks 
      rm ./backend.tf
      cd ..
    done

    # Remove if all environments are being cleaned.
    if [ -e ./shared/shared.auto.tfvars ]; then
      rm ./shared/shared.auto.tfvars
    fi
  else
      cd "./$1" && remove_symlinks && cd ..

      # A generated file from shared.auto.mod.tfvars
      echo "Leaving ./shared/shared.auto.tfvars intact."
      echo "Remove ./shared/shared.auto.tfvars manually if you wish."
  fi
}

# Requre one or two arguments
if [ "$#" -lt 1 -o "$#" -gt 2 ]; then
  usage
  exit 1
fi

# Check for valid arguments
if [ -n "$2" ]; then
  case "$2" in
    development)
      ;;
    production)
      ;;
    nonproduction)
      ;;
    *)
      usage
      exit 1
      ;;
  esac
fi

# only process valid input
case "$1" in
  clean)
    clean "$2"
    ;;
  prep)
    prep "$2"
    ;;
  *)
    usage
    exit 1
    ;;
esac

echo "$0 has run successfully"
exit 0
