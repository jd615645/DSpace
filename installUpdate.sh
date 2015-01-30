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
mkdir -p $log

echo "Src location: $dspace_src"
echo "Build Record location: $log"
echo "Is this OK? [Y/n]"
read ans
case "$ans" in
    y*|Y*) ;;
    *) exit 1 ;;
esac

cd $dspace_src

echo "=========== mvn package ===========" | tee -a $log/mvn.log
mvn -U clean package | tee -a $log/mvn.log
if [[ $? -ne 0 ]]; then
	echo "mvn failed!" | tee -a $log/err.log
fi;

cd ${dspace_src}/dspace/target/dspace-*-build/
if [[ $? -ne 0 ]]; then
	echo "cd into ${dspace_src}/dspace/target/dspace-*-build/ failed!" | tee -a $log/err.log
fi;

echo "=========== ant update ===========" | tee -a $log/ant.log
ant update | tee -a $log/ant.log

echo "=========== cleaning up ===========" | tee -a $log/cleanup.log
mkdir -p $log/bak $log/config-bak
for k in $(locate -b .bak- | grep $dspace_src);do mv -v $k $log/bak/ | tee -a $log/cleanup.log; done;
for k in $(locate -b .old | grep $dspace_src);do mv -v $k $log/config-bak/ | tee -a $log/cleanup.log; done;