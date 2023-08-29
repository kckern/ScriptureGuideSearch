FROM macbre/sphinxsearch

ARG  MYSQL_HOST
ARG  MYSQL_USER
ARG  MYSQL_PASS
ARG  MYSQL_DB
ARG  MYSQL_PORT
ENV MYSQL_HOST=${MYSQL_HOST}
ENV MYSQL_USER=${MYSQL_USER}
ENV MYSQL_PASS=${MYSQL_PASS}
ENV MYSQL_DB=${MYSQL_DB}
ENV MYSQL_PORT=${MYSQL_PORT}
USER root
RUN mkdir -p /var/lib/sphinx/data
COPY sphinx.conf /opt/sphinx/conf/sphinx.conf
EXPOSE 9306
RUN sed -i 's/MYSQL_HOST_PLACEHOLDER/'"$MYSQL_HOST"'/g' /opt/sphinx/conf/sphinx.conf && \
    sed -i 's/MYSQL_USER_PLACEHOLDER/'"$MYSQL_USER"'/g' /opt/sphinx/conf/sphinx.conf && \
    sed -i 's/MYSQL_PASS_PLACEHOLDER/'"$MYSQL_PASS"'/g' /opt/sphinx/conf/sphinx.conf && \
    sed -i 's/MYSQL_DB_PLACEHOLDER/'"$MYSQL_DB"'/g' /opt/sphinx/conf/sphinx.conf && \
    sed -i 's/MYSQL_PORT_PLACEHOLDER/'"$MYSQL_PORT"'/g' /opt/sphinx/conf/sphinx.conf && \
    cat /opt/sphinx/conf/sphinx.conf && \
    apk add --no-cache mysql-client && \
    printf "#!/bin/bash\n\
indexer sgindex --config /opt/sphinx/conf/sphinx.conf --rotate\n\
searchd --config /opt/sphinx/conf/sphinx.conf --nodetach" > /start.sh && \
    chmod +x /start.sh
CMD ["sh", "/start.sh"]

HEALTHCHECK --interval=5m --timeout=3s CMD mysql --port=9306 --execute="SHOW TABLES;" || exit 1