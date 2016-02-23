#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2016, Joyent, Inc.
#

SHELL=/bin/bash
GOPATH=$(PWD)/vendor
GOBUILDFLAGS=CGO_ENABLED=0

all: vendor dockerbuild-dl

.PHONY: check
check:
	@echo "Successfully checked nothing. :)"

clean:
	rm -f dockerbuild-dl

distclean: clean
	rm -rf vendor

dockerbuild-dl: dockerbuild-dl.go
	GOPATH=$(GOPATH) $(GOBUILDFLAGS) go build .

fmt:
	gofmt -w dockerbuild-dl.go

pkg: dockerbuild-dl
	@[[ -n "$(BRANCH)" ]] || (echo "missing BRANCH="; exit 1)
	@[[ -n "$(DESTDIR)" ]] || (echo "missing DESTDIR="; exit 1)
	./tools/mk-shar -b $(BRANCH) -o $(DESTDIR)

.PHONY: vendor
vendor:
	# Download dependencies.
	mkdir -p vendor/src/github.com/docker
	if [[ ! -d vendor/src/github.com/docker/docker ]]; then \
		git -C vendor/src/github.com/docker clone https://github.com/docker/docker.git; \
		git -C vendor/src/github.com/docker/docker checkout v1.10.2; \
	fi

	if [[ ! -d vendor/src/github.com/docker/go-units ]]; then \
		git -C vendor/src/github.com/docker clone https://github.com/docker/go-units.git; \
		git -C vendor/src/github.com/docker/go-units checkout v0.2.0; \
	fi

	# Get and patch go-curl files (to enable static ssl certs).
	mkdir -p vendor/src/github.com/christophwitzko
	if [[ ! -d vendor/src/github.com/christophwitzko/go-curl ]]; then \
		git -C vendor/src/github.com/christophwitzko clone https://github.com/christophwitzko/go-curl.git; \
		git -C vendor/src/github.com/christophwitzko/go-curl checkout 4bbbf2b1894ad8d31400b663a21360fb525107cf; \
		for p in $$(ls patches/go-curl-*); do echo "Executing patch file: $$p"; patch -p1 < "$$p"; done; \
	fi
