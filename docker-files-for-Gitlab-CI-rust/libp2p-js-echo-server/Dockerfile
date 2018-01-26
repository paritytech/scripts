FROM node
MAINTAINER Parity Technologies <devops@parity.io>


RUN mkdir /app
WORKDIR /app

ADD https://github.com/libp2p/js-libp2p/archive/4c81f39ebe75946feeadf6920101b61e329fb179.tar.gz /app/
RUN tar xf 4c81f39ebe75946feeadf6920101b61e329fb179.tar.gz --strip-components 1
RUN rm 4c81f39ebe75946feeadf6920101b61e329fb179.tar.gz

RUN npm install

EXPOSE 10333
CMD node /app/examples/echo/src/listener.js
