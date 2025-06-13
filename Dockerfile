# Use a build argument to allow the GitHub Action to specify the tag
ARG NEXTCLOUD_TAG=stable
FROM nextcloud:${NEXTCLOUD_TAG}

# Switch to the root user to install packages
USER root

# Install supervisor, cron, ffmpeg, and all other requested packages
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

# Redirect Apache logs to the container's stdout/stderr to bypass filesystem permission issues.
RUN echo "\nErrorLog /dev/stderr\nTransferLog /dev/stdout\n" > /etc/apache2/conf-available/docker-logs.conf \
    && a2enconf docker-logs

# CORRECTED: Create a cron log file and set its permissions
RUN touch /var/log/cron.log && chown www-data:www-data /var/log/cron.log

# CORRECTED: Create a more robust crontab file
# This version sources the environment and redirects output to the log file for debugging.
RUN echo "*/5 * * * * www-data /bin/bash -c 'source /etc/apache2/envvars && php -f /var/www/html/cron.php' >> /var/log/cron.log 2>&1" > /etc/cron.d/nextcloud-cron \
    && chmod 0644 /etc/cron.d/nextcloud-cron

# Copy the supervisor configuration file into the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# The CMD will now start supervisor, which in turn manages all other processes.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
