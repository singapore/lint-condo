FROM alpine:3.3

COPY provision.sh /
COPY package.json /

ENV GOPATH /gopath
ENV PATH /node_modules/.bin:$GOPATH/bin:$PATH

RUN apk add --no-cache bash && bash provision.sh

COPY . /usr/src/lint-condo

WORKDIR /src

ENTRYPOINT ["node", "/usr/src/lint-condo"]
