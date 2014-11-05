#!/bin/bash

# this will Quick reBuild Dspace
# more info please visit: https://wiki.duraspace.org/display/DSDOC3x/Rebuild+DSpace

if [ -z "$1" ]; then
	echo "usage:"
	echo "        $0 {log_path}"
	exit
fi
dspace_src="$PWD"

echo "=========== Src location: $dspace_src ===========" > $1

cd $dspace_src >> $1

echo "=========== mvn package ===========" >> $1
mvn -U clean package >> $1

cd ${dspace_src}/dspace/target/dspace*/ >> $1
ls
echo "=========== ant update ===========" >> $1
ant update >> $1

