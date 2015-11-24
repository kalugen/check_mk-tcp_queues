#!/bin/bash

# TODO: a lot of things...
#       1) it should be parametric
#       2) it should handle server/agent scenarios?
#       3) it should handle install/uninstall
#       4) it should detect or ask for paths and user/group instead of hardcoding them

# Setup the work parameters
SOURCEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )

CHECKDIR="/usr/share/check_mk/checks"
DOCDIR="/usr/share/doc/check_mk/checks"
TEMPLDIR="/usr/share/nagios/html/pnp4nagios/templates"
PERFDIR="/usr/share/check_mk/web/plugins/perfometer"
WATODIR="/usr/share/check_mk/web/plugins/wato"
AGENTPLUGINSDIR="/usr/share/check_mk/agents/plugins"

USER="apache"
GROUP="nagios"

CHECKNAME=$(basename $(ls -1 ${SOURCEDIR}/checks/* | head -n1))

# Start
echo "Generic CheckMK checks installation script"

# Copy the files to their destinations
cp -v ${SOURCEDIR}/checks/${CHECKNAME}*                  ${CHECKDIR}
cp -v ${SOURCEDIR}/docs/${CHECKNAME}*                    ${DOCDIR}
cp -v ${SOURCEDIR}/templates/check_mk-${CHECKNAME}*.php           ${TEMPLDIR}
cp -v ${SOURCEDIR}/perfometer/perfometer-${CHECKNAME}.py ${PERFDIR}
cp -v ${SOURCEDIR}/wato/${CHECKNAME}_rules.py            ${WATODIR}
cp -v ${SOURCEDIR}/agent/plugins/${CHECKNAME}            ${AGENTPLUGINSDIR}

# Fix the permissions
for __DIR in ${CHECKDIR} ${DOCDIR} ${TEMPLDIR} ${PERFDIR} ${WATODIR} ${AGENTPLUGINSDIR}; do
  chown ${USER}:${GROUP} -R ${__DIR}
  chmod ug+x ${__DIR}
done

# Restart apache mod_python (necessary only if we are installing WATO rules and modules)
service httpd stop
ipcs -s | grep apache | cut -f2 -d' ' | while read SEMID; do
  ipcrm -s ${SEMID}
done
service httpd start

exit 0
