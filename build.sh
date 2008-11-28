#!/bin/bash

# Copyright 2008 by Scott S. Goodwin

if [ ! -f "config.sh" ]; then
    echo "You aren't in the directory where build.sh is."
    exit 1
fi

source config.sh

/bin/mkdir -p exe
/bin/mkdir -p logs
/bin/mkdir -p var/db
/bin/mkdir -p var/src

if [ "$BUILD_DEBUG" == "yes" ] && [ "$SCRIPTON" != "yes" ]; then
    if [ -z "$(type -p script)" ]; then
        echo "WARNING: BUILD_DEBUG is set to 'yes', but the script executable cannot be found on your OS"
        echo "Continuing anyway in 5 seconds"
        sleep 5
    fi
    /usr/bin/env SCRIPTON="yes" script $SITEROOT/logs/build.log ./build.sh
    exit
fi

#
# Unpack and build each source package.
#

for SOURCE in $SOURCES; do
    cd $SITEROOT/var/src
	NAME=`echo $SOURCE | cut -f1 -d'-'`
	VERSION=`echo $SOURCE | cut -f2 -d'-'`
    if [ -d $SITEROOT/exe/$NAME ]; then
        echo "$SOURCE already installed in $SITEROOT/exe/$NAME"
        continue
    fi
    echo "$SOURCE - compiling"
    /bin/rm -rf $SOURCE
    echo "tar xjf $SITEROOT/src/${SOURCE}.tar.bz2 -- $PWD"
    tar xjf $SITEROOT/src/${SOURCE}.tar.bz2
    cd $SITEROOT/var/src/$SOURCE
	source $SITEROOT/make/$NAME
done

