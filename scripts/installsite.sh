#!/bin/bash

. ./lib/util.sh

# Start
echo "${NAME} ${VERSION} installation script"

if [[ ${DRYRUN} -gt 0 ]]; then
    # If we're not in dry-run mode, copy the files to their destinations
    cp -v ${SOURCEDIR}/checks/*                 ${CHECKDIR}/
    cp -v ${SOURCEDIR}/docs/*                   ${DOCDIR}/
    cp -v ${SOURCEDIR}/templates/*              ${TEMPLDIR}/
    cp -v ${SOURCEDIR}/web/plugins/perfometer/* ${WEBPLUGINSDIR}/perfometer
    cp -v ${SOURCEDIR}/web/plugins/wato/*       ${WEBPLUGINSDIR}/wato
    cp -v ${SOURCEDIR}/agent/plugins/*          ${AGENTSDIR}/
    cp -v ${SOURCEDIR}/agent/*                  ${AGENTSDIR}/plugins
    
    # Deploy the package info, making cmk package management aware of our modifications 
    # NOTE: this depends on the exported variables above
    ${SOURCEDIRE}/cmk_package.json > ${OMDBASE}/${SITE}/var/check_mk/packages/${NAME}

    # Fix the permissions, since we are running as root
    chown ${USER}:${GROUP} -R ${LOCALSHARE}
    
    # Stop apache and mod_python 
    omd stop ${SITE} apache
    
    # Clear any hanging SysV IPC semaphores while apache is down
    ipcs -s | grep ${USER} | cut -f2 -d' ' | while read SEMID; do
      ipcrm -s ${SEMID}
    done
    
    # Start apache and mod_python
    omd start ${SITE} apache
else 
    # If we are in dry-run mode, just display the package descriptor without writing anythng anywhere
    cat ${SOURCEDIRE}/cmk_package.json
fi 


exit 0
