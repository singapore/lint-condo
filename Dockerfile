FROM ruby:alpine

COPY provision.sh /
COPY package.json /

RUN sh provision.sh

COPY . /usr/src/lint-condo

ENV PATH /node_modules/.bin:$PATH

WORKDIR /src

ENTRYPOINT ["node", "/usr/src/lint-condo"]
