#!/bin/bash
set -e

# Start the cron service as root in the background.
# This ensures it has permissions to write its PID file.
/usr/sbin/cron -f &

# Execute the original command passed to the container (e.g., "apache2-foreground")
# This command will run as the default 'www-data' user defined in the Dockerfile.
exec "$@"
