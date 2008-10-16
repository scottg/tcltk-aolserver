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
# Site Settings
#

export SITEROOT=$PWD
export SITENAME="tcltk"
export SITEDESC="Tcl/Tk Conference 2008"
export SITEOWNER=$(/usr/bin/id -un)
export SITEGROUP=$(/usr/bin/id -gn)


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
export NS_SERVERLOG=$SITEROOT/nsd.log
export NS_ACCESSLOG=$SITEROOT/access.log
export NS_MAILHOST=smtp.hq.nasa.gov
export NS_MODULES=$SITEROOT/modules
export NS_PAGES=$SITEROOT/pages

#
# PostgreSQL Settings
#

export PGBIN=$SITEROOT/exe/postgresql/bin
export PGSHARE=$SITEROOT/exe/postgresql/share

export PGHOST=
export PGPORT=5432
export PGDBNAME=$SITENAME
export PGDATA=$SITEROOT/var/db

export PSQLARGS="--set ON_ERROR_STOP=1"
    # "--quiet"
    # "--no-align"
    # "--echo-all"

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
