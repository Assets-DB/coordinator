FROM postgres:15.3

ARG POSTGRES_USER=myuser
ARG POSTGRES_PASSWORD=mypassword
ARG POSTGRES_DB=mydb

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}

COPY creation_tables.sql /docker-entrypoint-initdb.d
COPY insertion_script/insertion_script.sql /docker-entrypoint-initdb.d

USER postgres

CMD ["postgres"]

EXPOSE 5432