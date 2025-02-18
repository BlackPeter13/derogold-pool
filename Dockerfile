# Why node:8 and not node:10? Because (a) v8 is LTS, so more likely to be stable, and (b) "npm update" on node:10 breaks on Docker on Linux (but not on OSX, oddly)
FROM node:10.24.0-slim

# Pool will not listen on ports if daemon is not available, so we'll use wait-for-it
# under docker swarm to delay starting pool until daemon is availabel on 11898
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs-legacy npm git libboost1.55-all libssl-dev \
  && rm -rf /var/lib/apt/lists/* && \
  chmod +x /wait-for-it.sh

ADD . /pool/
WORKDIR /pool/

RUN npm update

RUN mkdir -p /config

EXPOSE 8117
EXPOSE 3333
EXPOSE 5555
EXPOSE 7777

VOLUME ["/config"]

CMD node init.js -config=/config/config.json
