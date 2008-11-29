#!/bin/bash

if [ "$(id -un)" == "root" ]; then
    echo "You cannot run $0 as root"
    exit 1
fi

#
# Path setting.
#

export SITEROOT=$PWD

#
# Owner and Group settings.
#

export SITEOWNER=$(/usr/bin/id -un)
export SITEGROUP=$(/usr/bin/id -gn)

#
# If BUILD_DEBUG is set to -f, nsd will start in the foreground. If set to
# blank, it will start as a daemon.
#

export BUILD_DEBUG="yes"

#
# If NS_DEBUG is set to -f, nsd will start in the foreground. If set to blank,
# it will start as a daemon.
#

export NS_DEBUG="-f"

#
# Tcl Settings
#

export TCLBIN=$SITEROOT/exe/tcl/bin
export TCLSH_CMD="$TCLBIN/tclsh8.4"
export TCLLIBPATH="$SITEROOT/exe/tcl/lib/tcl8.4 $SITEROOT/exe/tcl/lib"

#
# AOLserver Settings
#

export NSROOT=$SITEROOT/exe/aolserver
export NSD_LOG=$SITEROOT/exe/aolserver/log/nspid.${SITENAME}
export NS_HTTPPORT=8000
export NS_HTTPSPORT=8001
export NS_HTTPSPORT_PKI=8002
if [ "$(uname)" == "Darwin" ]; then
	export NS_ADDRESS=127.0.0.1
	export NS_HOSTNAME=localhost
else
	export NS_ADDRESS=$(/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1)
	export NS_HOSTNAME=$(hostname)
fi
export NS_SERVERLOG=$SITEROOT/logs/nsd.log
export NS_ACCESSLOG=$SITEROOT/logs/access.log
export NS_MAILHOST=smtp.hq.nasa.gov
#export NS_MODULES=$SITEROOT/modules
#export NS_PAGES=$SITEROOT/pages

#
# PostgreSQL Settings
#

export PGBIN=$SITEROOT/exe/postgresql/bin
export PGSHARE=$SITEROOT/exe/postgresql/share

export PGHOST=
export PGPORT=5432
#export PGDBNAME=$SITENAME
export PGDATA=$SITEROOT/var/db

export PSQLARGS="--set ON_ERROR_STOP=1"
    # "--quiet"
    # "--no-align"
    # "--echo-all"

#
# Library and Manual Path Settings
#

# Adjust PATH
#if [[ $PATH != *$SITEROOT/bin* ]] ; then
#    echo "Adding $SITEROOT/bin to PATH"
#    export PATH=$SITEROOT/bin:$PATH
#    echo "PATH=$PATH"
#fi

# Adjust $DYLD_LIBRARY_PATH
#if [[ $DYLD_LIBRARY_PATH != *$SITEROOT/lib* ]] ; then
#    echo "Adding $SITEROOT/lib to DYLD_LIBRARY_PATH"
#    export DYLD_LIBRARY_PATH=$SITEROOT/lib:$DYLD_LIBRARY_PATH
#    echo "DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH"
#fi

# Adjust LD_LIBRARY_PATH
#if [[ $LD_LIBRARY_PATH != *$SITEROOT/lib* ]] ; then
#    echo "Adding $SITEROOT/lib to LD_LIBRARY_PATH"
#    export LD_LIBRARY_PATH=$SITEROOT/lib:$LD_LIBRARY_PATH
#    echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#fi

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
