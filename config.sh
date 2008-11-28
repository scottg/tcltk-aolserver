#!/bin/bash

if [ "$(id -un)" == "root" ]; then
    echo "You cannot run $0 as root"
    exit 1
fi

if [ ! -f "config.sh" ]; then
    echo "You aren't in the directory where build.sh is."
    exit 1
fi

#
# If BUILD_DEBUG is set to -f, nsd will start in the foreground. If set to
# blank, it will start as a daemon.
#

export BUILD_DEBUG="yes"

#
# Site Settings
#

export SITEROOT=$PWD
#export SITENAME="tcltk"
#export SITEDESC="Tcl/Tk Conference 2008"
#export SITEOWNER=$(/usr/bin/id -un)
#export SITEGROUP=$(/usr/bin/id -gn)

#
# Tcl Settings
#

export TCLBIN=$SITEROOT/exe/tcl/bin
export TCLSH_CMD="$TCLBIN/tclsh8.4"
export TCLLIBPATH="$SITEROOT/exe/tcl/lib/tcl8.4 $SITEROOT/exe/tcl/lib"

#
# Library and Manual Path Settings
#


#
# Sources to Compile and Install
#

export SOURCES="
    tcl-8.4.19
    postgresql-8.3.4
    sqlite-3.6.3
    aolserver-cvs
    nspostgres-cvs
    nsopenssl-cvs
    nssqlite3-cvs
"
