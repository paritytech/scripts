FROM node
MAINTAINER Parity Technologies <devops@parity.io>

RUN git clone https://github.com/libp2p/js-libp2p && \
    cd js-libp2p && \
    git checkout 4c81f39ebe75946feeadf6920101b61e329fb179 && \
    cd ..

RUN cd js-libp2p && \
    npm install && \
    cd ..

CMD node ./js-libp2p/examples/echo/src/listener.js
