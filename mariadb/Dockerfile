# Parent image

FROM bitnami/mariadb:11.1.2-debian-11-r0

# Variables

ENV MARIADB_ROOT_PASSWORD root123
ENV MARIADB_DATABASE wdemo
ENV MARIADB_USER dew
ENV MARIADB_PASSWORD dew123

# Copy schema and script

COPY wdemo-schema.sql /tmp
COPY wdemo-schema.sh /tmp

