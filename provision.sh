#!/bin/sh

cd /

apk update
apk add --no-cache \
    nodejs \
    python \
    python-dev \
    py-pip \
    go

gem install scss_lint -v 0.48.0
gem sources -c

pip --no-cache-dir install yamllint==1.2.1 proselint==0.5.3
apk del py-pip

go get -u github.com/alecthomas/gometalinter
gometalinter --install --update
go clean all
apk del go
rm -Rf /usr/lib/go
rm -Rf /gopath/src
rm -Rf /gopath/pkg

npm -q install
npm cache clean

mkdir -p /src
