This repository contains a sdc-docker-build helper, which is used to download
remote URLs during the docker build process. A single `dockerbuild-dl` is
generated, that will be copied into the appropriate sdc folder, which is then
available for sdc-docker-build to run during it's docker build steps.

External code repositories (downloaded during `make` build):

* go-curl for http(s) requests:
  https://github.com/christophwitzko/go-curl
* Static root x509 (ssl) certificates:
  https://github.com/kelseyhightower/contributors
* JSONMessage (and dependencies):
  https://github.com/docker/docker/blob/master/pkg/jsonmessage/
  https://github.com/docker/go-units
