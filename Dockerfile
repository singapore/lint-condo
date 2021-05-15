FROM mhart/alpine-node:6@sha256:48874d4dc78e35984d6e962d389563fb70ba4f3358c1fe9ed27f7968484c0105
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
