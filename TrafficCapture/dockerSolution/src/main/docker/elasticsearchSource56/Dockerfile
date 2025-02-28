FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.16

# Custom configuration for empty source cluster
ENV ELASTIC_SEARCH_CONFIG_FILE=/usr/share/elasticsearch/config/elasticsearch.yml
RUN elasticsearch-plugin install --batch repository-s3
RUN echo "discovery.type: single-node" >> $ELASTIC_SEARCH_CONFIG_FILE
RUN echo "xpack.security.enabled: false" >> $ELASTIC_SEARCH_CONFIG_FILE
RUN echo "bootstrap.system_call_filter: false" >> $ELASTIC_SEARCH_CONFIG_FILE
# COPY elasticsearch.yml /usr/share/elasticsearch/config/
VOLUME ["/snapshots"]

EXPOSE 9200 9300
