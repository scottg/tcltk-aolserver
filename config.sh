#!/bin/bash

# XXX Running as root is needed to use dtruss / dtrace on Mac OS X
#if [ "$(id -un)" == "root" ]; then
#    echo "You cannot run $0 as root"
#    return 1
#fi

#
# Path setting.
#

export SITEROOT=$PWD

#
# The sources.sh file tells us what to build. It shouldn't be committed to the
# repository, and if it doesn't exist, we'll create it here.
#

DEFAULT_SOURCES="
	tcl-8.5.18
	aolserver-3.5.11
"

# XXX will probably have to create separate 'build' files to handle differences
# XXX between different versions of the same package, but that's for later.

#tls-1.6
#tcllib-1.11
#postgresql-8.3.4
#pgtcl-1.5
#sqlite-3.6.6.2
#aolserver-cvs
#nspostgres-cvs
#nsopenssl-cvs
#nssqlite3-cvs

if [ ! -f "$SITEROOT/sources.sh" ]; then
	echo "Building the sources.sh file to tell us what to build"
	echo "Modify this file to build the versions you want for each package"
	echo "But DO NOT commit this file to the repository"

	echo "# Don't commit this file to the repository" > $SITEROOT/sources.sh
	echo "" >> $SITEROOT/sources.sh
	echo "export SOURCES=\"" >> $SITEROOT/sources.sh
	for SOURCE in $DEFAULT_SOURCES; do
		echo "	$SOURCE" >> $SITEROOT/sources.sh
	done
	echo "\"" >> $SITEROOT/sources.sh	
fi

#
# EXE is where everything is installed
#

export EXE=$SITEROOT/exe

#
# Set SITEPATH based on whether a site name was passed in the second argument.
# If it wasn't then we used 'default' as the site name.
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
if [ "$(id -un)" == "root" ]; then
	export SITEDESC="=== NOT SET ==="
	export SITEOWNER=$(ls -la config.sh | tr -s ' '  | cut -f3 -d' ')
	export SITEGROUP=$(ls -la config.sh | tr -s ' '  | cut -f4 -d' ')
fi

#
# If BUILD_DEBUG is set to "yes", the build will be scripted and logged.
#

export BUILD_DEBUG="yes"

#
# If the DEBUG file exists in the SITEROOT directory, NS_DEBUG is set to -f so
# that nsd will start in the foreground.
#

export NS_DEBUG=""
if [ -f $SITEROOT/DEBUG ]; then
	export NS_DEBUG="-f"
fi

#
# Tcl Settings
#

if [ -f $EXE/tcl/lib/tclConfig.sh ]; then
	source $EXE/tcl/lib/tclConfig.sh
	export TCLBIN=$EXE/tcl/bin
	export TCLSH_CMD="$TCLBIN/tclsh${TCL_VERSION}"
	export TCLLIBPATH="
		$EXE/tcl/lib/tcl${TCL_VERSION}
		$EXE/tcl/lib
		$EXE/tcllib/lib
		$EXE/pgtcl/lib
		$EXE/tls/lib
	"
else
	echo "Local Tcl version not installed yet. Can't set Tcl paths."
	export TCLBIN=
	export TCLSH_CMD=
	export TCLLIBPATH=
fi

#
# AOLserver Settings
#

export NSROOT=$EXE/aolserver
export NSD_LOG=$EXE/aolserver/log/nspid.${SITENAME}
export NS_HTTPPORT=8000
export NS_HTTPSPORT=8001
export NS_HTTPSPORT_PKI=8002

LOOPBACK=127.0.0.1
NONROUTABLE=192.168.
export NS_ADDRESS=$(/sbin/ifconfig -a | awk '/(cast)/ { print $2 }' | cut -d':' -f2 | head -1)
export NS_HOSTNAME=$(hostname)
if [[ "$NS_ADDRESS" =~ "$NONROUTABLE" && ! "$NS_ADDRESS" =~ "$LOOPBACK" ]]; then
	export NS_ADDRESS=127.0.0.1
	export NS_HOSTNAME=localhost
fi

export NS_SERVERLOG=$SITEROOT/logs/nsd.log
export NS_ACCESSLOG=$SITEROOT/logs/access.log
export NS_MAILHOST=smtp.hq.nasa.gov
#export NS_MODULES=$SITEROOT/modules
#export NS_PAGES=$SITEROOT/pages

#
# PostgreSQL Settings
#

export PGBIN=$EXE/postgresql/bin
export PGSHARE=$EXE/postgresql/share

export PGHOST=
export PGPORT=5432
export PGDATA=$SITEROOT/var/db
export PGDBNAME=$SITENAME
export PGCLIENTENCODING=UTF-8
export PSQLARGS="--set ON_ERROR_STOP=1"
    # "--quiet"
    # "--no-align"
    # "--echo-all"

#
# Library and Manual Path Settings
#

source paths.sh

#
# Sources to Compile and Install
#

source sources.sh
