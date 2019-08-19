FROM ubuntu:16.04

ARG quiet='-q -y -o Dpkg::Use-Pty=0'

#Install node.js
RUN apt-get update $quiet &&\
    apt-get install $quiet curl &&\
    curl -sL https://deb.nodesource.com/setup_10.x |  bash - &&\
    apt-get update $quiet  &&\
    apt-get install $quiet nodejs git

ARG BRANCH

#Install twig.js & webpack dependencies
RUN git clone https://github.com/twigjs/twig.js.git &&\
    cd twig.js &&\
    git checkout -b build ${BRANCH} &&\
    npm install &&\
    npm install --save-dev \
      @babel/core \
      @babel/runtime \
      @babel/plugin-proposal-class-properties \
      @babel/plugin-transform-regenerator \
      @babel/plugin-transform-runtime \
      @babel/preset-env \
      babel-loader \
      string-replace-loader \
      webpack \
      webpack-cli

#Copy build files
COPY ./twig.js /twig.js


ARG MODE

RUN cd twig.js && ./node_modules/.bin/webpack
