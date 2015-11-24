#!/bin/bash

. ./scripts/lib/util.sh

ruby ${SOURCEDIR}/scripts/lib/write_package_descriptor.rb >> ${SOURCEDIR}/.cmkpackage.json
