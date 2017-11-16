FROM mhart/alpine-node:6@sha256:3f6e4fb4040db0c5b2c0c0c5e73addea414eee7cd3c31bdfb9d84a03bf0505be
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
