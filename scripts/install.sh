SOURCEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )
SITE_BLACKLIST="pippo"

/usr/bin/omd  sites | grep -v SITE | awk '{print $1}' | grep -vE "${SITE_BLACKLIST}" | while read SITE; do

    # Install the appropriate files in the correct positions inside the site
    ${SOURCEDIR}/scripts/installsite.sh ${SITE}

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

done
