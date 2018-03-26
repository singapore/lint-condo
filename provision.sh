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
    python python-dev py-pip \
    ruby ruby-json \
    build-base

# ---------------
# install linters
# ---------------
gem install scss_lint -v 0.48.0 -N

go get -u gopkg.in/alecthomas/gometalinter.v1
ln -s $GOPATH/bin/gometalinter.v1 $GOPATH/bin/gometalinter

npm -q install

pip --no-cache-dir install -r requirements.txt

npm cache clean

mkdir -p /usr/src/shellcheck
cd /usr/src/shellcheck 
git clone https://github.com/koalaman/shellcheck .

apk add --no-cache --repository https://s3-us-west-2.amazonaws.com/alpine-ghc/7.10 --allow-untrusted ghc cabal-install stack  
cabal update 
cabal install 
cabal clean
rm -rf /usr/src/shellcheck

# -------------
# clean sources
# -------------

gem sources -c
rm -Rf /gopath/src
rm -Rf /gopath/pkg
rm -Rf /usr/lib/go

apk del python-dev git go build-base ghc cabal-install stack 

# -------------
# create target
# -------------

mkdir -p /src
