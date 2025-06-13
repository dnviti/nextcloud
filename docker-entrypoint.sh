#!/bin/bash
set -e

# Start the cron service as root in the background.
/usr/sbin/cron -f &

# Use gosu to drop from root to the non-privileged 'www-data' user
# and then execute the main command passed to this script (e.g., "apache2-foreground").
# The Apache logging is now handled by a separate config file, so no chown is needed here.
exec gosu www-data "$@"
