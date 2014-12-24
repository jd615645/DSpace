#!/bin/bash

# this will Quick reBuild Dspace
# more info please visit: https://wiki.duraspace.org/display/DSDOC3x/Rebuild+DSpace

if [ -z "$1" ]; then
	echo "usage:"
	echo "        $0 {log_path}"
	exit
fi
dspace_src="$( cd "$( dirname "$0" )" && pwd )"
log="$(cd $(dirname $1); pwd)/$(basename $1)"
echo "=========== Src location: $dspace_src ===========" > $log

cd $dspace_src >> $log

echo "=========== mvn package ===========" >> $log
mvn -U clean package >> $log

cd ${dspace_src}/dspace/target/dspace*/ >> $log

echo "=========== ant update ===========" >> $log
ant update >> $log

