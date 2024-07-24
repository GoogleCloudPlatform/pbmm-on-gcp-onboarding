# How to install Fortigate

1. Symlink two Fortigate license files into this directory. Name the symlinks license1.lic and license2.lic.
  1. ln -s /path/to/mylicense1.lic ./license1.lic
  2. ln -s /path/to/mylicense2.lic ./license2.1ic
2. Run the prepare.sh script from the 7-fortigate directory. 
  1. ./prepare.sh prep 
3. In testing, I used the sa-terraform-org (note "org") to apply my terraform.
4. From the "shared" directory, perform the usual terraform init, plan, apply sequence.

## Behind the scenes 

If you look into the prepare.sh script you will see that it does the following:
- Activates any shell script helpers (chmod 755)
- Identifies the location of the existing tf state bucket
- Confirms that two Fortigate licenses are present
