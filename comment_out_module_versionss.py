import os
import re
import sys
from enum import Enum

# list of extensions to replace
# DEFAULT_REPLACE_EXTENSIONS = None
# example: uncomment next line to only replace *.c, *.h, and/or *.txt
# e.g. DEFAULT_REPLACE_EXTENSIONS = (".c", ".h", ".txt")
# TBD: this script has to be integrated with localize_terraform_modules.py - it will be done sometime
# for now just run it after
DEFAULT_REPLACE_EXTENSIONS = (".tf")
      
## pat_replace = list( ([re.compile(one_re_find_repl[0]),one_re_find_repl[1]] for one_re_find_repl in regex_find_replace))
re_match_module = r'^[^\r\n\S]*module[^\r\n\S]+"[^\r\n"]+"[^\r\n\S]*\{[^\r\n\S]*$'
pat_match_module = re.compile(re_match_module)

re_match_version = r'^([^\r\n\S]*)(version[^\r\n\S]*=[^\r\n\S]*"[^\r\n\S]*[<>~=\d\.]+[^\r\n\S]*"[^\r\n]*)$'
re_repl_version = r'\1## localized \2'
pat_match_version = re.compile(re_match_version)

re_match_source = r'^[^\r\n\S]*source[^\r\n\S]*=[^\r\n\S]*"[\./]+(terraform|Google)[^\r\n"]+"[^\r\n\S]*$'
pat_match_source = re.compile(re_match_source)

re_match_count = r'^[^\r\n\S]*(count|for_each)[^\r\n\S]+[^\r\n"]+$'
pat_match_count = re.compile(re_match_count)

re_match_empty = r'^[^\r\n\S]*$'
pat_match_empty = re.compile(re_match_empty)

num_replacements = 0
num_patched_files = 0
num_scanned_files = 0

def try_to_replace(fname, replace_extensions=DEFAULT_REPLACE_EXTENSIONS):
    if replace_extensions:
        return fname.lower().endswith(replace_extensions)
    return True

class Parse_State(Enum):
    Scanning = 0
    ModuleStart = 1
    InModule = 2
    ModuleEnd = 3

##def file_replace(fname, pat, s_after):
def file_replace(fname):
    global num_replacements, num_patched_files, num_scanned_files
    # first, see if the pattern is even in the file.
    with open(fname) as f:
        lines = f.readlines()
        f.close()
    num_scanned_files += 1    
    patch_applied=0    
    parse_state =  Parse_State.Scanning   
    for line_index in range(len(lines)):
        line = lines[line_index]
        if parse_state == Parse_State.Scanning and re.search(pat_match_module,line):
           parse_state = Parse_State.ModuleStart 
        elif  parse_state == Parse_State.ModuleStart or parse_state == Parse_State.InModule:
            if re.search(pat_match_version,line):
                repl_line = re.sub(pat_match_version,re_repl_version,line)
                lines[line_index] = repl_line
                patch_applied += 1
                num_replacements += 1
                print("replacing:" + line + " with:\n"+ repl_line + " in file:" + fname) 
            elif re.search(pat_match_source,line) or re.search(pat_match_count,line) or re.search(pat_match_empty,line):
                parse_state = Parse_State.InModule
            else:    
                parse_state = Parse_State.Scanning
    if patch_applied > 0:
        num_patched_files += 1
        out_fname = fname + ".tmp"
        out = open(out_fname, "w")
        for line in lines:
            out.write(line)
        out.close()
        os.remove(fname)
        os.rename(out_fname, fname)


def file_replace_mod(fname):
    global num_replacements, num_patched_files, num_scanned_files
    # first, see if the pattern is even in the file.
    with open(fname) as f:
        lines = f.readlines()
        f.close()
    num_scanned_files += 1    
    patch_applied=0    
    start_line_index = 0
    end_line_range = len(lines)
    while start_line_index < end_line_range:
        module_block_found = False
        version_search_index_start = start_line_index
        version_search_index_end = end_line_range
        for line_index in range(start_line_index, end_line_range):
           # search module declaration 
           line = lines[line_index]
           if re.search(pat_match_module,line):
               # module block start found, determine module block end
               module_block_found = True
               version_search_index_start = line_index + 1
               indent_level = 0
               for line_index_tmp in range(line_index,end_line_range):
                   line = lines[line_index_tmp]
                   count_open_bracket = line.count("{")
                   count_close_bracket = line.count("}")
                   indent_level += count_open_bracket - count_close_bracket
                   if indent_level == 0:
                       version_search_index_end = line_index_tmp
                       break
               # if module start line exit loop will restart with new start line
               break
        # no more module blocks  
        if not module_block_found:
           break
        source_attribute_found = False
        for line_index_tmp in range(version_search_index_start,version_search_index_end):
           line = lines[line_index_tmp] 
           if re.search(pat_match_source,line):
               source_attribute_found = True
               break
        if source_attribute_found:
            for line_index_tmp in range(version_search_index_start,version_search_index_end):
               line = lines[line_index_tmp] 
               if re.search(pat_match_version,line):
                   repl_line = re.sub(pat_match_version,re_repl_version,line)
                   lines[line_index_tmp] = repl_line
                   patch_applied += 1
                   num_replacements += 1
                   print("replacing:" + line + " with:\n"+ repl_line + " in file:" + fname) 
                   break
        # restart the for loop after each module block 
        start_line_index = version_search_index_end + 1
                
    if patch_applied > 0:
        num_patched_files += 1
        out_fname = fname + ".tmp"
        out = open(out_fname, "w")
        for line in lines:
           out.write(line)
        out.close()
        os.remove(fname)
        os.rename(out_fname, fname)



def mass_replace(root_dir, crt_dir, replace_extensions=DEFAULT_REPLACE_EXTENSIONS):
##  print("crt_dir="+crt_dir+"\n")
    for dirpath, dirnames, filenames in os.walk(os.path.abspath(crt_dir)):
        for fname in filenames:
            if try_to_replace(fname, replace_extensions):
                fullname = os.path.join(dirpath, fname)
                file_replace_mod(fullname)
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
   print("Replaced {} instances in {} files out of {} scanned files".format(num_replacements,num_patched_files,num_scanned_files))
    
##    sys.exit(1)
##mass_replace(sys.argv[1])