FROM ruby:alpine

COPY provision.sh /
COPY package.json /

ENV GOPATH /gopath
ENV PATH /node_modules/.bin:$GOPATH/bin:$PATH

RUN sh provision.sh

COPY . /usr/src/lint-condo

WORKDIR /src

ENTRYPOINT ["node", "/usr/src/lint-condo"]
