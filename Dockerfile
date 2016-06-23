FROM ruby:alpine

COPY provision.sh /
COPY package.json /

RUN sh provision.sh

COPY . /usr/src/lint-condo

ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH /node_modules/.bin:$GOPATH/bin:$PATH

WORKDIR /src

ENTRYPOINT ["node", "/usr/src/lint-condo"]
