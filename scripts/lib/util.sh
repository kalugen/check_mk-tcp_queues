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

LOCALSHARE="${OMDBASE}/${SITE}/local/share"
CHECKDIR="${LOCALSHARE}/check_mk/checks"
DOCDIR="${LOCALSHARE}/doc/check_mk"
TEMPLDIR="${LOCALSHARE}/check_mk/pnp-templates"
WEBPLUGINSDIR="${LOCALSHARE}/check_mk/web/plugins"
AGENTSDIR="${LOCALSHARE}/check_mk/agents"
