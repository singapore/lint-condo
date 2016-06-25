#!/bin/sh

cd /
# -----------------
# install languages
# -----------------

echo "http://dl-cdn.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v3.3/community" >> /etc/apk/repositories

apk update
apk add --no-cache \
    go \
    nodejs=4.3.0-r0 \
    python \
    python-dev \
    py-pip \
    git

# ---------------
# install linters
# ---------------
gem install scss_lint -v 0.48.0

go get -u github.com/alecthomas/gometalinter
gometalinter --install --update

npm -q install

pip --no-cache-dir install yamllint==1.2.1 proselint==0.5.3

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
