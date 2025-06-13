# Use a build argument for the base image tag, defaulting to stable
ARG NEXTCLOUD_TAG=stable
FROM nextcloud:${NEXTCLOUD_TAG}

# Switch to the root user to install packages
USER root

# Install supervisor and all your other required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor \
    cron \
    ffmpeg \
    ghostscript \
    graphicsmagick \
    imagemagick \
    iputils-ping \
    java-common \
    default-jre \
    libmagickcore-6.q16-6-extra \
    mc \
    btop \
    nmap \
    ncdu \
    net-tools \
    smbclient \
    && rm -rf /var/lib/apt/lists/*

# Copy the supervisor configuration file into the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Redirect Apache logs to stdout/stderr to bypass filesystem permission issues.
RUN echo "\nErrorLog /dev/stderr\nTransferLog /dev/stdout\n" > /etc/apache2/conf-available/docker-logs.conf \
    && a2enconf docker-logs

# The CMD will now start supervisor, which in turn manages all other processes.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
