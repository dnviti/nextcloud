#!/bin/bash
set -e

# Start the cron service as root in the background.
/usr/sbin/cron -f &

# Change ownership of the apache log directory to the www-data user.
# This ensures that Apache, when running as www-data, can write to its logs.
chown -R www-data:www-data /var/log/apache2

# Use gosu to drop from root to the non-privileged 'www-data' user
# and then execute the main command passed to this script (e.g., "apache2-foreground").
exec gosu www-data "$@"
