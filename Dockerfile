FROM mhart/alpine-node:6@sha256:8400b14a216bd21d74763e291902bd3aa97e61cfac9d309cfc919c98ec761170
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
