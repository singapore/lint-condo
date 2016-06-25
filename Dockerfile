FROM ruby:alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.3/community" >> /etc/apk/repositories
RUN apk update

RUN apk add --no-cache \
    nodejs=4.3.0-r0 \
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
