#!/bin/bash

# Setup the work parameters
SOURCEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )
OMDBASE="/omd/sites"

# Checks if the site name was passed
if [[ ${1} == "" ]]; then
  echo "Indicare il site!"
  exit 255
else 
  SITE=${1}
fi

# Dry-run option
if [[ ${2} == "-n" ]]; then
  DRYRUN=1
else 
  DRYRUN=0
fi

# Assume that $SITE is also the user and group name
# as is the standard for OMD. 
# TODO: figure out how to actually determine these values from OMD config
USER=${SITE}
GROUP=${SITE}

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

LOCALSHARE="${OMDBASE}/${SITE}/local/share"
CHECKDIR="${LOCALSHARE}/check_mk/checks"
DOCDIR="${LOCALSHARE}/doc/check_mk"
TEMPLDIR="${LOCALSHARE}/check_mk/pnp-templates"
WEBPLUGINSDIR="${LOCALSHARE}/check_mk/web/plugins"
AGENTSDIR="${LOCALSHARE}/check_mk/agents"
