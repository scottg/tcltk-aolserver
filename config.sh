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
# Set SITEPATH based on whether a site name was passed in the second argument.
#

if [ -z "$2" ]; then
	export SITENAME=default
else
	export SITENAME=$2
fi
echo "Site Name is $SITENAME"

if [ -d "$SITENAME" ]; then
	export SITEPATH=$SITENAME
elif [ -d "../$SITENAME" ]; then
	export SITEPATH="$(cd ../$SITENAME; echo $PWD)"
else
	echo "Cannot find $SITENAME directory here or in ../$SITENAME"
	sleep 5;
	exit 1
fi

#
# Owner and Group settings.
#

export SITEDESC="=== NOT SET ==="
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

if [ -f $SITEROOT/exe/tcl/lib/tclConfig.sh ]; then
	source $SITEROOT/exe/tcl/lib/tclConfig.sh
	export TCLBIN=$SITEROOT/exe/tcl/bin
	export TCLSH_CMD="$TCLBIN/tclsh${TCL_VERSION}"
	export TCLLIBPATH="$SITEROOT/exe/tcl/lib/tcl${TCL_VERSION} $SITEROOT/exe/tcl/lib"
else
	echo "Local Tcl version not installed yet. Can't set Tcl paths."
	export TCLBIN=
	export TCLSH_CMD=
	export TCLLIBPATH=
fi

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
export PGDATA=$SITEROOT/var/db
export PGDBNAME=$SITENAME
export PSQLARGS="--set ON_ERROR_STOP=1"
    # "--quiet"
    # "--no-align"
    # "--echo-all"

#
# Library and Manual Path Settings
#

# Adjust PATH
if [[ $PATH != *$SITEROOT/exe/tcl/bin* ]] && [ -d $SITEROOT/exe/tcl/bin ]; then
    echo "Adding $SITEROOT/exe/tcl/bin to PATH"
    export PATH=$SITEROOT/exe/tcl/bin:$PATH
    echo "PATH=$PATH"
fi

# Adjust $DYLD_LIBRARY_PATH
if [[ $DYLD_LIBRARY_PATH != *$SITEROOT/exe/tcl/lib* ]] && [ ! -z "$TCLLIBPATH" ] ; then
    echo "Adding local Tcl libraries to DYLD_LIBRARY_PATH"
    export DYLD_LIBRARY_PATH=$SITEROOT/exe/tcl/lib:$SITEROOT/exe/tcl/lib/tcl${TCL_VERSION}/sqlite3:$SITEROOT/exe/sqlite/lib:$DYLD_LIBRARY_PATH
    echo "DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH"
fi
export LD_LIBRARY_PATH=$DYLD_LIBRARY_PATH

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
    tcl-8.5.5
    postgresql-8.3.4
    sqlite-3.6.6.2
    aolserver-cvs
    nspostgres-cvs
    nsopenssl-cvs
    nssqlite3-cvs
"
