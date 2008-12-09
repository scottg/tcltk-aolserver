#!/bin/bash

#
# This dynamically resets path environment variables to ensure local copies
# take precedence over system copies. It is meant to be sourced by config.sh
# and no one else.
#

unset NEWBINPATH
unset NEWLIBPATH
unset NEWMANPATH

PATHS="
	$EXE/aolserver
	$EXE/tcl
	$EXE/postgresql
	$EXE/sqlite
	$EXE/pgtcl

	$HOME/local
	$HOME/opt
	/local
	/opt/local
	/opt
	/
	/usr
	/usr/share
	/usr/local/share
"

for P in $PATHS
do
    [ -d "$P/bin" ] && NEWBINPATH=${NEWBINPATH}:$P/bin
    [ -d "$P/sbin" ] && NEWBINPATH=${NEWBINPATH}:$P/sbin

    [ -d "$P/lib" ] && NEWLIBPATH=${NEWLIBPATH}:$P/lib
    [ -d "$P/lib/tcl$TCL_VERSION}" ] && NEWLIBPATH=${NEWLIBPATH}:$P/lib/tcl$TCL_VERSION

    [ -d "$P/man" ] && NEWMANPATH=${NEWMANPATH}:$P/man
    [ -d "$P/share/man" ] && NEWMANPATH=${NEWMANPATH}:$P/share/man

done

# Clean up path strings

NEWBINPATH=$(echo $NEWBINPATH | /usr/bin/sed 's/^://' | /usr/bin/sed 's+//+/+g')
NEWLIBPATH=$(echo $NEWLIBPATH | /usr/bin/sed 's/^://' | /usr/bin/sed 's+//+/+g')
NEWMANPATH=$(echo $NEWMANPATH | /usr/bin/sed 's/^://' | /usr/bin/sed 's+//+/+g')

# Export the paths

#export PATH=/bin:/sbin:/usr/bin:/usr/sbin
#export PATH=$PATH:~/local/bin:/local/bin:/opt/local/bin:/opt/local/sbin

#[ ! -z "$NEWBINPATH" ] && export PATH=$NEWBINPATH:$PATH

export PATH=$NEWBINPATH

export LD_LIBRARY_PATH=$NEWLIBPATH
export DYLD_LIBRARY_PATH=$NEWLIBPATH
export MANPATH=$NEWMANPATH

# Clean up the environment

unset PATHS
unset NEWBINPATH
unset NEWLIBPATH
unset NEWMANPATH

