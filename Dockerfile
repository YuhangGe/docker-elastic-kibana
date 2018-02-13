FROM openjdk:jre

LABEL maintainer "Yuhang Ge <abeyuhang@gmail.com>"

ENV ES_VERSION=6.2.1 \
    KIBANA_VERSION=6.2.1

RUN apt-get update
RUN apt-get -y install bash wget
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs
RUN npm --version


RUN useradd -ms /bin/bash elasticsearch
USER elasticsearch

WORKDIR /home/elasticsearch

RUN wget -q -O - https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz \
 |  tar -zx \
 && mv elasticsearch-${ES_VERSION} elasticsearch \
 && wget -q -O - https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz \
 |  tar -zx \
 && mv kibana-${KIBANA_VERSION}-linux-x86_64 kibana \
 && rm -f kibana/node/bin/node kibana/node/bin/npm \
 && ln -s $(which node) kibana/node/bin/node \
 && ln -s $(which npm) kibana/node/bin/npm

RUN mkdir /home/elasticsearch/data && chown -R elasticsearch /home/elasticsearch/data
CMD elasticsearch/bin/elasticsearch -E path.data=/home/elasticsearch/data -E discovery.type=single-node -E http.host=0.0.0.0 & kibana/bin/kibana --host 0.0.0.0


EXPOSE 9200 5601 9100