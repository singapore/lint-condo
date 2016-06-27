#!/usr/bin/env bash

set -e

apk update
apk add musl-dev

cd /hadolint/repo
#stack build --allow-different-user
cabal update
cabal install

cp /root/.cabal/bin/hadolint /hadolint/bin
