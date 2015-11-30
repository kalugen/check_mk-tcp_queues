#!/bin/bash

# Setup the work parameters
SOURCEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )

# Gets the version from Git tags or just uses date-time
if [[ $(git status 2>/dev/null) ]]; then
  TAG=$(git tag | tail -n1)
fi

# Package Descriptor Variables
export AUTHOR="MIS Monitoring Desk"
export CMK_MIN_VERSION="1.2.6p1"
export CMK_PKG_VERSION="1.2.6p12"
export DESCRIPTION="Package Descr"
export NAME="tcp_queues"
export TITLE="TCP Queue Monitor"
export URL="http://mxplgitas01.mbdom.mbgroup.ad/Monitoring/check_mk-tcp_queues"

if [[ "" != "${TAG}" ]]; then
  VERSION=${TAG}
else
  VERSION=$(date +'%Y%m%d-%H%M%S')
fi
export VERSION

# Now populate files arrays: this is needed for custom package descriptors
pushd ${SOURCEDIR}/agents > /dev/null
export AGENTS=$(find . -type f|xargs|sed 's/ /,/g; s/.\///g')
popd > /dev/null

pushd ${SOURCEDIR}/docs > /dev/null
export CHECKMAN=$(find . -type f|xargs|sed 's/ /,/g; s/.\///g')
popd > /dev/null

pushd ${SOURCEDIR}/checks > /dev/null
export CHECKS=$(find . -type f|xargs|sed 's/ /,/g; s/.\///g')
popd > /dev/null

pushd ${SOURCEDIR}/templates > /dev/null
export PNP_TEMPLATES=$(find . -type f|xargs|sed 's/ /,/g; s/.\///g')
popd > /dev/null

pushd ${SOURCEDIR}/web > /dev/null
export WEB=$(find . -type f|xargs|sed 's/ /,/g; s/.\///g')
popd > /dev/null

