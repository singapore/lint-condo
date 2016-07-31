#!/usr/bin/env bash

set -e
cd /
# -----------------
# install languages
# -----------------

apk update
apk add --no-cache \
    git \
    go \
    nodejs=4.3.0-r0 \
    python python-dev py-pip \
    ruby ruby-json

# ---------------
# install linters
# ---------------
gem install scss_lint -v 0.48.0 -N

go get -u gopkg.in/alecthomas/gometalinter.v1
ln -s $GOPATH/bin/gometalinter.v1 $GOPATH/bin/gometalinter

npm -q install

pip --no-cache-dir install -r requirements.txt

# -------------
# clean sources
# -------------
gem sources -c
rm -Rf /gopath/src
rm -Rf /gopath/pkg
rm -Rf /usr/lib/go

npm cache clean
apk del python-dev git go

# -------------
# create target
# -------------

mkdir -p /src
