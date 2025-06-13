#!/bin/bash
set -e

# Start the cron service as root in the background.
# This ensures it has permissions to write its PID file.
/usr/sbin/cron -f &

# Use gosu to drop from root to the non-privileged 'www-data' user
# and then execute the main command passed to this script (e.g., "apache2-foreground").
exec gosu www-data "$@"
