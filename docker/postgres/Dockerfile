FROM postgres:16-alpine

COPY init-user.sh /docker-entrypoint-initdb.d/init-user.sh

RUN chmod +x /docker-entrypoint-initdb.d/init-user.sh