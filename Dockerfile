# Use a build argument for the base image tag, defaulting to stable
ARG NEXTCLOUD_TAG=stable
FROM nextcloud:${NEXTCLOUD_TAG}

# Switch to the root user to gain permissions for installation
USER root

# Install gosu for privilege de-escalation, plus all your required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    gosu \
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

# Create a crontab file for the Nextcloud cron job
RUN echo "*/5  * * * * www-data php -f /var/www/html/cron.php" > /etc/cron.d/nextcloud-cron \
    # Give execution rights on the cron job
    && chmod 0644 /etc/cron.d/nextcloud-cron

# Copy the custom entrypoint script into the container
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set the new entrypoint. This will run as root.
ENTRYPOINT ["docker-entrypoint.sh"]

# The original entrypoint becomes the default command passed to our script
CMD ["apache2-foreground"]
