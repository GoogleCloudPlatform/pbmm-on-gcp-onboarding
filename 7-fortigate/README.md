# How to install Fortigate

1. Symlink two Fortigate license files into this directory. Name the symlinks license1.lic and license2.lic.
  1. ln -s /path/to/mylicense1.lic license1.lic
  2. ln -s /path/to/mylicense2.lic license2.1ic
2. Run the prepare.sh script from this directory. 
  1. ./prepare.sh prep
3. In testing, I used the sa-terraform-org@prj-b-seed-082b.iam.gserviceaccount.com to apply my terraform.
4. From each of the three envionment directories, perform the usual terraform init, plan, apply sequence.
  1. cd development && terraform init
  2. cd development && terraform plan
  3. cd development && terraform apply

## NB - This code makes a number of assumptions about networking.
We will need a wider deployment to confirm that none of the current assumptions are invalid.
For the time being, try deploying only the development sources as the production and non-production
resources could do with more testing. This is probably a good thing in the short term, as each environment
requires two additional Fortigate licenses.

## Behind the scenes 

If you look into the prepare.sh script you will see that it does the following:
- Activates any shell script helpers (chmod 755)
- Identifies the location of the existing tf state bucket
- Confirms that two Fortigate licenses are present
- Symlinks common resources into the development, production, and nonproduction directories
