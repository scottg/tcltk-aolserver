#!/bin/bash

# Copyright 2008 by Scott S. Goodwin

#
# We unpack all sources into var/src.
#

cd $SITEROOT/var/src

#
# Figure out the name and version of the package to be compiled and installed.
# This require that the name of the tar.bz2 file be <NAME>-<VERSION>.tar.bz2
#

NAME=`echo $SOURCE | cut -f1 -d'-'`
VERSION=`echo $SOURCE | cut -f2 -d'-'`

#
# If there is an executable directory for this package, and it's the same
# version, then we don't do a reinstall unless forced to. If we're trying to
# install a different version of this package, then we remove the old version's
# executables and source code and do the new install.
#
# XXX Right now, the version is appended to the source directory's name.
# XXX I might want to change that, or I may want to leave multiple versions
# XXX of the package.
#

if [ -f ${SITEROOT}/var/src/${NAME}-{$VERSION} ]; then
	# XXX figure out how to force a rebuild when necessary
	echo "$SOURCE already installed in $EXE/$NAME"
else
	# It's not the right version - remove the existing version
	echo "Removing existing version of $NAME and the markers for it"
	/bin/rm -rf $EXE/${NAME}
	/bin/rm -rf $SITEROOT/var/${NAME}-*
fi

#
# Unpack the specified tar.bz2 file
#

echo "$SOURCE - unpacking"
/bin/rm -rf $SOURCE
echo "tar xjf $SITEROOT/build/src/${SOURCE}.tar.bz2 -- $PWD"
tar xjf $SITEROOT/build/src/${SOURCE}.tar.bz2
cd $SITEROOT/var/src/$SOURCE

#
# Each build specification is in a separate build file
#

echo "$SOURCE - compiling"
source $SITEROOT/build/make/$NAME
touch $SITEROOT/var/${NAME}-${VERSION}

#
# Source config.sh after each package is built to pick up anything new,
# like Tcl paths 
#

cd $SITEROOT
source config.sh

