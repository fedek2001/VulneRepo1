FROM node:20.10-slim AS base

WORKDIR /app

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y fontforge ttfautohint curl gnupg python3.11 qtbase5-dev openldap-utils libharfbuzz-dev \
    && apt-get -y upgrade && apt-get -y autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV YARN_VERSION 1.22.10

RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz

FROM node:20.10-slim AS final-base

WORKDIR /app

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y fontforge ttfautohint python3.11  \
    && apt-get -y upgrade && apt-get -y autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Inicia el servicio de Nginx cuando se ejecute el contenedor
ENTRYPOINT ["/app/startup.sh"]
