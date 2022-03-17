##############################################
# Replaces a regex pattern in a file. 
# $1 is the pattern
# $2 is the replacement
# $3 is the file
##############################################
function gres () {
    if [ $# -lt "3" ] 
    then 
        echo Usage: gres pattern replacement file
        exit 1
    fi

    pattern=$1
    replacement=$2

    if [ -f $3 ] 
    then 
        file=$3
    else
        echo $3 is not a file.
        exit 1
    fi

    A="`echo | tr '\012' '\001' `"
    sed -i -e "s$A$pattern$A$replacement$A" $file
}
