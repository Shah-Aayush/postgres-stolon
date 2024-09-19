ARG PGVERSION

# base build image
FROM golang:1.16-buster AS build_base

WORKDIR /stolon

# only copy go.mod and go.sum
COPY go.mod .
COPY go.sum .

RUN go mod download

#######
####### Build the stolon binaries
#######
FROM build_base AS builder

# copy all the sources
COPY . .

RUN make

#######
####### Build the final image
#######
FROM postgres:$PGVERSION

###### --- START ---

USER root

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl \
    build-essential postgresql-server-dev-15 libcurl4-openssl-dev libssl-dev git \
    postgresql-plpython3-15 python3-pip \
    python3-boto3 postgresql-contrib-15 jq vim

# Download and install the Citus columnar package
RUN wget https://github.com/rbernierZulu/columnar-tables-extension/raw/main/postgresql-15-citus-columnar_11.1-1-UBUNTU2004_amd64.deb -O /tmp/columnar-package.deb && \
    apt-get install -y /tmp/columnar-package.deb && \
    rm /tmp/columnar-package.deb

# Download and install pg_profile extension
RUN wget https://github.com/zubkov-andrei/pg_profile/releases/download/4.6/pg_profile--4.6.tar.gz -O /tmp/pg_profile.tar.gz && \
    mkdir -p /usr/share/postgresql/15/extension && \
    tar xzf /tmp/pg_profile.tar.gz --directory /usr/share/postgresql/15/extension && \
    rm /tmp/pg_profile.tar.gz

# Clone the aws-s3 extension repository
RUN git clone https://github.com/chimpler/postgres-aws-s3 /tmp/postgres-aws-s3

# Build and install the extension
RUN cd /tmp/postgres-aws-s3 \
    && make \
    && make install

# Create SQL script to install extensions
RUN echo "CREATE EXTENSION IF NOT EXISTS plpython3u;" >> /docker-entrypoint-initdb.d/init_extensions.sql && \
    echo "CREATE EXTENSION IF NOT EXISTS aws_s3 CASCADE;" >> /docker-entrypoint-initdb.d/init_extensions.sql && \
    echo "CREATE EXTENSION IF NOT EXISTS citus_columnar;" >> /docker-entrypoint-initdb.d/init_extensions.sql && \
    echo "CREATE EXTENSION IF NOT EXISTS dblink;" >> /docker-entrypoint-initdb.d/init_extensions.sql && \
    echo "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;" >> /docker-entrypoint-initdb.d/init_extensions.sql && \
    echo "CREATE EXTENSION IF NOT EXISTS pg_profile;" >> /docker-entrypoint-initdb.d/init_extensions.sql

# Modify postgresql.conf to include shared_preload_libraries
RUN echo "shared_preload_libraries = 'pg_stat_statements'" >> /usr/share/postgresql/postgresql.conf.sample

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

###### --- END ---
RUN useradd -ms /bin/bash stolon

EXPOSE 5432

# copy the agola-web dist
COPY --from=builder /stolon/bin/ /usr/local/bin

RUN chmod +x /usr/local/bin/stolon-keeper /usr/local/bin/stolon-sentinel /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl
