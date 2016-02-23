#!/bin/bash
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2015, Joyent, Inc.
#

set -o errexit
set -o xtrace

TMP=/var/tmp

mkdir -p /opt/smartdc/docker/bin
cp ${TMP}/dockerbuild-dl/dockerbuild-dl /opt/smartdc/docker/bin/
cp ${TMP}/dockerbuild-dl/dockerbuild-dl-setup.sh /opt/smartdc/docker/bin/
chmod 0755 /opt/smartdc/docker/bin/*
cp ${TMP}/dockerbuild-dl/dockerbuild-dl.xml /var/svc/manifest/site/
svcadm disable dockerbuild-dl || /bin/true
svccfg delete dockerbuild-dl || /bin/true
svccfg import /var/svc/manifest/site/dockerbuild-dl.xml
svcadm refresh dockerbuild-dl

exit 0
