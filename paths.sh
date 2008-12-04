#!/bin/bash

#
# This dynamically resets path environment variables. It is meant to be sourced
# by config.sh and no one else.
#

PATHS="
    aolserver
	tcl
	postgresql
	sqlite
	pgtcl
"

unset NEWBINPATH
unset NEWLIBPATH
unset NEWMANPATH

for P in $PATHS
do
    [ -d "$EXE/$P/bin" ] && NEWBINPATH=${NEWBINPATH}:$EXE/$P/bin
    [ -d "$EXE/$P/sbin" ] && NEWBINPATH=${NEWBINPATH}:$EXE/$P/sbin

    [ -d "$EXE/$P/lib" ] && NEWLIBPATH=${NEWLIBPATH}:$EXE/$P/lib
    [ -d "$EXE/$P/lib/tcl$TCL_VERSION}" ] && NEWLIBPATH=${NEWLIBPATH}:$EXE/$P/lib/tcl$TCL_VERSION

    [ -d "$EXE/$P/man" ] && NEWMANPATH=${NEWBINPATH}:$EXE/$P/man
    [ -d "$EXE/$P/share/man" ] && NEWMANPATH=${NEWBINPATH}:$EXE/$P/share/man

done

# Clean up path strings

NEWBINPATH=$(echo $NEWBINPATH | /usr/bin/sed 's/^://' | /usr/bin/sed 's+//+/+g')
NEWLIBPATH=$(echo $NEWLIBPATH | /usr/bin/sed 's/^://' | /usr/bin/sed 's+//+/+g')
NEWMANPATH=$(echo $NEWMANPATH | /usr/bin/sed 's/^://' | /usr/bin/sed 's+//+/+g')

# Export the paths

export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH=$PATH:~/local/bin:/local/bin:/opt/local/bin:/opt/local/sbin

[ ! -z "$NEWBINPATH" ] && export PATH=$NEWBINPATH:$PATH

export LD_LIBRARY_PATH=$NEWLIBPATH
export DYLD_LIBRARY_PATH=$NEWLIBPATH
export MANPATH=$NEWMANPATH

# Clean up the environment

unset PATHS
unset NEWBINPATH
unset NEWLIBPATH
unset NEWMANPATH

