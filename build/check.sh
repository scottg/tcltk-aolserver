#!/bin/bash

# Copyright 2008 by Scott S. Goodwin

# We always want to be in top level directory
cd $(dirname $0)/..

source config.sh

#
# Confirm that all files are in place.
#

FILES="
	aolserver/bin/nsd
	aolserver/bin/nsopenssl.so
	aolserver/bin/nspostgres.so
	aolserver/bin/nssqlite3.so
	postgresql/bin/initdb
	tcl/bin/tclsh
	tcl/lib/pgtcl1.5/libpgtcl1.5g.dylib
	tcl/lib/tls1.6/libtls1.6.dylib
"

FAILED=0
for FILE in $FILES; do
	if [ ! -e "$EXE/$FILE" ]; then
		echo "FAILED: $EXE/$FILE is not in place"
        FAILED=1
	fi
done

if [ "$FAILED" = "0" ]; then
    echo "Everything appears to be in order."
fi

