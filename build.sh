#!/bin/bash

# Copyright 2008 by Scott S. Goodwin

if [ ! -f "config.sh" ]; then
    echo "You aren't in the directory where build.sh is."
    exit 1
fi

source config.sh

/bin/mkdir -p exe
/bin/mkdir -p var/db

#
# Unpack and build each source package.
#

for SOURCE in $SOURCES; do
    cd $SITEROOT/src
	NAME=`echo $SOURCE | cut -f1 -d'-'`
	VERSION=`echo $SOURCE | cut -f2 -d'-'`
    if [ -d $SITEROOT/exe/$NAME ]; then
        echo "$SOURCE already installed in $SITEROOT/exe/$NAME"
        continue
    fi
    echo "$SOURCE - compiling"
    /bin/rm -rf $SOURCE
    echo "tar xjf ${SOURCE}.tar.bz2 -- $PWD"
    tar xjf ${SOURCE}.tar.bz2
    cd $SITEROOT/src/$SOURCE
	source $SITEROOT/make/$NAME
done

