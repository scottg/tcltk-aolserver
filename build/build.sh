#!/bin/bash

# Copyright 2008 by Scott S. Goodwin

#
# We always want to be in top level directory. This makes sure we're there.
# 

cd $(dirname $0)/..

source config.sh

/bin/mkdir -p $EXE
/bin/mkdir -p $SITEROOT/logs
/bin/mkdir -p $SITEROOT/var/db
/bin/mkdir -p $SITEROOT/var/src

# IS_SCRIPT_ON is turned on here so we don't loop through this over and over again
 
if [ "$IS_SCRIPT_ON" != "yes" ]; then
    if [ -z "$(type -p script)" ]; then
        echo "WARNING: BUILD_DEBUG is set to 'yes', but the script executable cannot be found on your OS"
        echo "Continuing anyway in 5 seconds"
        sleep 5
    fi
    /usr/bin/env IS_SCRIPT_ON="yes" script $SITEROOT/logs/build.log $SITEROOT/build/build.sh $1
    exit
fi

#
# Unpack and build each source package. If a specific package isn't passed in,
# then pass the list of packages stored in $SOURCES.
#

if [ ! -z "$1" ]; then
	SOURCES="$1"
fi

#
# Build the package(s)
#

for SOURCE in $SOURCES; do
    source $SITEROOT/build/compile.sh $SOURCE
done

