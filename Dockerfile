FROM mhart/alpine-node:16@sha256:c9014e9e5b33f29d47c867ea548edc0235ba71677f40456409a44c278d8a8e01
MAINTAINER Rhys Arkins <rhys@keylocation.sg>

LABEL name="lint-condo" version="1.0"

COPY provision.sh /
COPY requirements.txt /
COPY package.json /

ENV GOPATH /gopath
ENV PATH /node_modules/.bin:$GOPATH/bin:$PATH

RUN apk add --no-cache bash && bash provision.sh

COPY src /usr/src/lint-condo

WORKDIR /src

CMD ["node", "/usr/src/lint-condo"]
