#!/bin/bash
set -e

# Start the cron service in the background.
cron

# Execute the original command (e.g., "apache2-foreground")
exec "$@"
