# -
# `VERSION` contains the current version - aka the last tagged version of the
# repository. It's stored in a file named `VERSION` and should only ever be
# updated by running `make next`.
#
# `NEXT_VERSION` contains the next version number which is generated using the
# date and contains: the two-digit year, the week number, day of week and hour.
#
# `next` updates the `VERSION` file with the `NEXT_VERSION` value which
# signifies a new version has been reached and will be released.
# `release` applies the `VERSION` to the repository by tagging the current
# repository state with the `VERSION` value and then pushes the repo to the
# git server. It's important that your `.git/config` file contains the necessary
# `push` fields under the `origin` remote (or whatever remote you use).
# -

VERSION := $(shell cat VERSION)
NEXT_VERSION := $(shell date -u +%yw%W.%w.%H)

next:
	echo $(NEXT_VERSION) > VERSION

release:
	# re-tag this commit
	-git tag -d $(VERSION)
	git tag $(VERSION)
	# note: this requires that the configuration contains:
	# [remote "origin"]
	#     url = ...
	#     fetch = +refs/heads/*:refs/remotes/origin/*
	#     push = +refs/heads/*
	#     push = +refs/tags/*
	# in order to force tags to push alongside everything else.
	git push


#
# This file should contain tasks for building and running the service
#


# -
# Docker
# -

build: static
	docker build -t southclaws/tw-SERVICE_NAME:$(VERSION) .

push:
	docker push southclaws/tw-SERVICE_NAME:$(VERSION)

run:
	docker run \
		--name SERVICE_NAME \
		--env-file .env \
		southclaws/tw-SERVICE_NAME:$(VERSION)
