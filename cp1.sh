#!/bin/bash
#filename   : cp1.sh   reviewed 2
#description: copy the file "start.txt" to another the file "mine.txt". 
#             If the string "start" is found inside "start.txt" 
#             replace it for "XXXX" in the process. 
#             if an input arg is provided, the source file name will 
#             be the input argument instead of "start.txt"
#************************************************************


#test arguments
VERSION=1.0
 
if [[ $# -gt 1 ]]           #more than one argument
then 
    echo $0: Too many arguments. Program abort!
    exit 1 
fi

if [[ $# -eq 1 ]]         #one argument
then
    case "$1" in
    --help)
        echo 
        echo $0: Copy the file \"start.txt\" to \"mine.txt\"
        echo $0: replacing any character sequence "start" to "XXXX" in destination
        echo $0: A source file can be provided as first argument. ex  cp1.sh [filename.ext]
        exit 
        ;;
    -v)
        echo $0: version number $VERSION
        exit
        ;;      
    *)
        sourcefile=$1
        ;;
    esac
else
    sourcefile="./start.txt"
fi    


#**********************************************************
#test for source file existance and r permission
#use of && AND. execute command2 only if command1 is True
[ ! -f $sourcefile ] && { echo $0: File does not exist in the current directory. Program Abort!; exit 1; }

#test for read access
[[ ! -r $sourcefile ]] && { echo $0: File does not allow read access. Program Abort!; exit 1; }



#**********************************************************
#test for write access to the target directory (current)
dirname=`pwd`
if [[ ! -w $dirname ]]
then 
    echo $0: you must have w permission in the directory $dirname
    exit 1
fi



#**********************************************************
#test if destination file exist
newfile=$dirname/"mine.txt"
if [[ -e $newfile ]]
then
   echo $0: $newfile already exist and I will not harm it.
   exit 1
fi



#**********************************************************
#test existance of the sed program
#use of || OR. execute command2 only if command1 is FALSE
command -v sed &> /dev/null || { echo $0: Sed program not found. Program Abort!; exit 1; }



#**********************************************************
#replace string "start" with "XXXX" and copy results on a new file mine.txt
if ! sed 's/start/XXXX/g' $sourcefile > $newfile
then
   echo $0: The sed command exit status was $?
    exit 1
fi



#*********************************************************
#test chmod to enable read permision of the new file
if ! chmod 444 $newfile
then
    echo $0: the chmod exit status was $?
    exit 1
fi

