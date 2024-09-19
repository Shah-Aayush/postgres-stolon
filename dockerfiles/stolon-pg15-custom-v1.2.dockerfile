# Stage 1: Build the extensions
FROM postgres:15 AS builder

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

# Stage 2: Create the final image
FROM sorintlab/stolon:master-pg15

USER root

# Copy the extensions and configuration from the builder stage
COPY --from=builder /usr/lib/postgresql/15/lib /usr/lib/postgresql/15/lib
COPY --from=builder /usr/share/postgresql/15/extension /usr/share/postgresql/15/extension
COPY --from=builder /usr/share/postgresql/postgresql.conf.sample /usr/share/postgresql/postgresql.conf.sample
COPY --from=builder /docker-entrypoint-initdb.d/init_extensions.sql /docker-entrypoint-initdb.d/init_extensions.sql

# Set locale
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Ensure permissions are correct
RUN chmod +x /usr/local/bin/stolon-keeper /usr/local/bin/stolon-sentinel /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl

EXPOSE 5432