FROM mhart/alpine-node:6@sha256:084cf753830635c4da8668089c1eaed3dd1c323a0453c823fb3ef05357d2bbf5
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
