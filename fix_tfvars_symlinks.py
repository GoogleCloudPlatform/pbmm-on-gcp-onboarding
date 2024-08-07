import os
import re
import sys
import shutil

# Problem : when git cloning from github symlinks become text in files
# e.g. 3-networks-hub-and-spoke\envs\development\common.auto.tfvars : ../../common.auto.tfvars
# not only .auto.tfvars but also .tfvars
# to find them use regex   r'^[\./]+[^\W\./]+\.auto\.tfvars' or better r'^[\./]+[^\n]+\.tfvars'

# this should have been a symlink. If on Windows symlinks not available
# if the referenced file does not exist most likely because we have examples something like
# access_context.auto.example.tfvars, common.auto.example.tfvars, etc
# however if git-cloned on Linux the symlinks remain symlinks and the script will only fix the broken ones
# the fix consists in creating thje missing file referenced by the symlink with a text ### fill-me-in with tfvars definitions

# list of extensions to replace
# DEFAULT_REPLACE_EXTENSIONS = None
# example: uncomment next line to only replace *.c, *.h, and/or *.txt
# DEFAULT_REPLACE_EXTENSIONS = (".c", ".h", ".txt")
DEFAULT_TFVAR_EXTENSIONS = (".tfvars")
regex_find_symlink =  r'^[\./]+([^\n/]+)\.tfvars'
regex_find_mod_tfvars =  r'^([^\n\./]+(\.auto|))\.mod(\.tfvars)'
re_repl_mod_tfvars = r'\1\3'
regex_find_tfvars =  r'^([^\n\./]+(\.auto|))\.tfvars'

fixed_fake_symlinked_count = 0
fixed_tfvars_symlinked_count = 0
fix_symlink_error_count = 0

# pat_replace = list( ([re.compile(one_re_find_repl[0]),one_re_find_repl[1]] for one_re_find_repl in regex_find_replace))
pat_find_symlink = re.compile(regex_find_symlink)
pat_find_mod_tfvars = re.compile(regex_find_mod_tfvars)
pat_find_tfvars = re.compile(regex_find_tfvars)

def check_file_type(fname, tfvar_extensions=DEFAULT_TFVAR_EXTENSIONS):
    if tfvar_extensions:
        return fname.lower().endswith(tfvar_extensions)
    return False

## do not overwrite destination if exists
def create_symlink_or_hardcopy(src_file_path, dst_file_path):
    if os.path.exists(dst_file_path):
        return (dst_file_path,"exists")
    try:
        os.symlink(src_file_path, dst_file_path)
        return (dst_file_path,"symlink")
    except:
        print("Could not symlink {} to {}".format(src_file_path,dst_file_path))
    try:
        shutil.copy2(src_file_path,dst_file_path)
        return (dst_file_path,"hardlink")
    except:
        print("Could not copy {} to {}".format(src_file_path,dst_file_path))
    return None


# if a <fname>.mod.tfvars file exists but not a <fname>.tfvars file, a symlink or hardcopy is created
# first a symlink creation attempted, if it fails a hardcopy is created
def create_mod_tfvars_symlink_or_hardcopy(fname, dirpath):
    tfvars_full_path = None
    tfvars_mod_full_path = None
    if re.search(pat_find_mod_tfvars,fname):
        tfvars_fname = re.sub(pat_find_mod_tfvars,re_repl_mod_tfvars,fname)
        tfvars_full_path = os.path.join(dirpath,tfvars_fname)
        tfvars_mod_full_path = os.path.join(dirpath,fname)
    if (tfvars_full_path is None):
        return None
    result = create_symlink_or_hardcopy(tfvars_mod_full_path,tfvars_full_path)
    return result


## looks for <name>.mod.tfvars files and checks if a symlink exists to them in same folder
## if no symlink, will either create one or (Windows non-admin) will simply copy the file
##
def fix_mod_tfvars_symlinks(src_fname, dirpath):
    global fixed_tfvars_symlinked_count
    global fix_symlink_error_count
    # normalize just in case if src_fname is a path
    fname = os.path.basename(src_fname)
    fname_abs_path = os.path.join(dirpath,fname)
    # first create symlink to a .mod.tfvars in same folder
    if re.match(pat_find_mod_tfvars,fname):
        result = create_mod_tfvars_symlink_or_hardcopy(fname,dirpath)
        if result is None:
            print("error symlinking {} in {}".format(fname,dirpath))
            fix_symlink_error_count += 1
        elif re.match(r'exists',result[1]):
            ## for some reason called twice on same file
            print("error symlinking {} in {}, destination {} already exists".format(fname,dirpath,result[0]))
            ## silently ignore if dest file already exists
            return
        elif re.match(r'symlink',result[1]):
            print("symlinked {} in {} to {}".format(fname,dirpath,result[0]))
            fixed_tfvars_symlinked_count += 1
        elif re.match(r'hardlink',result[1]):
            print("copied {} in {} to {}".format(fname,dirpath,result[0]))
            fixed_tfvars_symlinked_count += 1



def fix_tfvars_symlinks(src_fname, dirpath):
    global fixed_fake_symlinked_count
    global fix_symlink_error_count
    global pat_find_symlink
    # normalize just in case if src_fname is a path
    fname = os.path.basename(src_fname)
    fname_abs_path = os.path.join(dirpath,fname)

    if re.match(pat_find_tfvars,fname):
        if not os.path.islink(fname_abs_path):
            tfvars_path_above = None
            symlink_path = None
            lines = None
            try:
                with open(fname_abs_path,'r') as f:
                    lines = f.readlines()
                    f.close()
            except:
                print("can't open file {}".format(fname_abs_path))
                fix_symlink_error_count += 1
                return
            if len(lines) == 1 and re.match(pat_find_symlink, lines[0]):
                symlink_path = lines[0]
                tfvars_path_above = os.path.join(dirpath,symlink_path)
            else:
                return
            # exit if error
            if tfvars_path_above is None or not os.path.exists(tfvars_path_above):
                print("missing source tfvars file" + "" if tfvars_path_above is None else tfvars_path_above)
                fix_symlink_error_count += 1
                return
            # rename source file and try to create symlink, otherwise hard copy
            print("renaming " + fname_abs_path + "\n to " + fname_abs_path + ".delete_me")
            os.rename(fname_abs_path,  fname_abs_path +'.delete_me')
            if create_symlink_or_hardcopy(tfvars_path_above,fname_abs_path) is not None:
               print("symlinked " + tfvars_path_above + "\n to " + fname_abs_path)
               fixed_fake_symlinked_count += 1
            else:
               fix_symlink_error_count += 1
               print("error symlinking " + tfvars_path_above + "\n to " + fname_abs_path)

        else:
            try:
                tfvars_path_above = os.readlink(fname_abs_path)
                if not os.path.isabs(tfvars_path_above):
                    tfvars_path_above = os.path.join(dirpath,tfvars_path_above)
                if tfvars_path_above is not None and os.path.exists(tfvars_path_above):
                    return
                print("Broken symlink {} to {}".format(fname_abs_path,tfvars_path_above) if tfvars_path_above is not None else "" )
                print("Broken symlink in {}".format(fname_abs_path) if tfvars_path_above is None else "")
            except:
                 print("can't get symlink from file {}".format( fname_abs_path))
                 fix_symlink_error_count += 1





def get_relative_dir_string(root_dir, current_dir):
    abs_root_dir = os.path.abspath(root_dir)
    abs_current_dir = os.path.abspath(current_dir)
    rel_path = os.path.relpath(abs_current_dir, start=abs_root_dir).replace(os.sep,'/')
    return rel_path


def mass_fix_mod_tfvars(root_dir, crt_dir, replace_extensions=DEFAULT_TFVAR_EXTENSIONS):
    for dirpath, dirnames, filenames in os.walk(os.path.abspath(crt_dir)):
        for fname in filenames:
            if check_file_type(fname, replace_extensions):
                fullname = os.path.join(dirpath, fname)
                fix_mod_tfvars_symlinks(fullname, dirpath)

def mass_fix_symlinks(root_dir, crt_dir, replace_extensions=DEFAULT_TFVAR_EXTENSIONS):
##  print("crt_dir="+crt_dir+"\n")
    for dirpath, dirnames, filenames in os.walk(os.path.abspath(crt_dir)):
        for fname in filenames:
            if check_file_type(fname, replace_extensions):
                fullname = os.path.join(dirpath, fname)
                fix_tfvars_symlinks(fullname, dirpath)

def main(root_dir):
   mass_fix_mod_tfvars(root_dir,root_dir)
   mass_fix_symlinks(root_dir,root_dir)

if __name__ == "__main__":
   if len(sys.argv) != 2:
      print("Usage: fix_fake_symlinks.py <root_dir>\n")
      sys.exit()
   main(sys.argv[1])



   print("fixed " + str(fixed_fake_symlinked_count) + " fake symlinks and " +  str(fixed_tfvars_symlinked_count) + " fixed_tfvars_symlinked_count " + str(fix_symlink_error_count) + " errors" )

##    sys.exit(1)
##mass_replace(sys.argv[1])
