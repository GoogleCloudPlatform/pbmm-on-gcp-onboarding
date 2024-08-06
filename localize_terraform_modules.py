import os
import re
import sys

# list of extensions to replace
# DEFAULT_REPLACE_EXTENSIONS = None
# example: uncomment next line to only replace *.c, *.h, and/or *.txt
# DEFAULT_REPLACE_EXTENSIONS = (".c", ".h", ".txt")
DEFAULT_REPLACE_EXTENSIONS = (".tf")
regex_find_replace =  [
      [r'"terraform-google-modules/', r'/terraform-google-modules/'],
      [r'"GoogleCloudPlatform/', r'/GoogleCloudPlatform/']
 ]
      
pat_replace = list( ([re.compile(one_re_find_repl[0]),one_re_find_repl[1]] for one_re_find_repl in regex_find_replace))


def try_to_replace(fname, replace_extensions=DEFAULT_REPLACE_EXTENSIONS):
    if replace_extensions:
        return fname.lower().endswith(replace_extensions)
    return True


##def file_replace(fname, pat, s_after):
def file_replace(fname, pat_replace, s_prefix):
    # first, see if the pattern is even in the file.
    for one_pat_replace in pat_replace:
        pat = one_pat_replace[0] 
        repl = one_pat_replace[1]
        with open(fname) as f:
            if not any(re.search(pat, line) for line in f):
                f.close()
                continue # pattern does not occur in file so we are done.
            f.close()    
        with open(fname) as f:
        # pattern is in the file, so perform replace operation.
            out_fname = fname + ".tmp"
            out = open(out_fname, "w")
            for line in f:
               if re.search(pat, line):
                  s_after = s_prefix + repl
                  out.write(re.sub(pat, s_after, line))
                  print("replacing:"+line+" with:\n"+re.sub(pat, s_after, line)+" in file:"+fname) 
               else:
                  out.write(line) 
            f.close()
            os.remove(fname)
            out.close()
            os.rename(out_fname, fname)

def get_relative_dir_string(root_dir, current_dir):
    abs_root_dir = os.path.abspath(root_dir)
    abs_current_dir = os.path.abspath(current_dir)
    rel_path = os.path.relpath(os.path.abspath(current_dir), start=os.path.abspath(root_dir)).replace(os.sep,'/')
    return rel_path


def mass_replace(root_dir, crt_dir, replace_extensions=DEFAULT_REPLACE_EXTENSIONS):
##  print("crt_dir="+crt_dir+"\n")
    for dirpath, dirnames, filenames in os.walk(os.path.abspath(crt_dir)):
        s_prefix='"'+ get_relative_dir_string(dirpath,root_dir)
        for fname in filenames:
            if try_to_replace(fname, replace_extensions):
                fullname = os.path.join(dirpath, fname)
                file_replace(fullname, pat_replace, s_prefix)
        for dirname in dirnames:
            mass_replace(root_dir,os.path.join(crt_dir,dirname))
            
def main(root_dir):
#   root_dir = (r'C:\Users\romma05\Documents\ZA-GCP-v3-TEF\terraform-example-foundation').replace(os.sep,'/')
   mass_replace(root_dir,root_dir)

if __name__ == "__main__":
   if len(sys.argv) != 2:
      print("Usage: localize_terraform_modules.py <root_dir>\n")
      exit()
   main(sys.argv[1])
    
##    sys.exit(1)
##mass_replace(sys.argv[1])