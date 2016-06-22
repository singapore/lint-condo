FROM ruby:alpine

RUN apk add --no-cache \
    build-base \
    nodejs \
    python \
    python-dev \
    py-pip

RUN gem install scss_lint -v 0.48.0 && gem sources -c
RUN pip --no-cache-dir install yamllint==1.2.1 proselint==0.5.3

COPY package.json /
RUN cd / && npm -q install && npm cache clean

RUN mkdir -p /src

COPY . /usr/src/lint-condo

ENV PATH /node_modules/.bin:$PATH

WORKDIR /src

ENTRYPOINT ["node", "/usr/src/lint-condo"]
