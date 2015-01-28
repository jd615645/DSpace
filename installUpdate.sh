#!/bin/bash

# this will Full Refresh/Rebuild DSpace
# more info please visit: https://wiki.duraspace.org/display/DSDOC3x/Rebuild+DSpace
# This assume that you use a symlink to the webapp

if [ -z "$1" ]; then
	echo "usage:"
	echo "        $0 {log_path}"
	exit
fi
dspace_src="$( cd "$( dirname "$0" )" && pwd )"
log="$(cd $(dirname $1); pwd)/$(basename $1)"

echo "Src location: $dspace_src"
echo "Log location: $log"
echo "Is this OK? [Y/n]"
read ans
case "$ans" in
    y*|Y*) ;;
    *) exit 1 ;;
esac

cd $dspace_src

echo "=========== mvn package ===========" | tee $log
mvn -U clean package | tee $log
if [[ $? -ne 0 ]]; then
	echo "mvn failed!" | tee $log
fi;

cd ${dspace_src}/dspace/target/dspace-*-build/
if [[ $? -ne 0 ]]; then
	echo "cd into ${dspace_src}/dspace/target/dspace-*-build/ failed!" | tee $log
fi;

echo "=========== ant update ===========" | tee $log
ant update | tee $log

