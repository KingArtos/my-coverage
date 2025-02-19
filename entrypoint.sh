#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

while ! nc -z db 5432; do sleep 3; done

echo ">>> Setuping..."
bundle exec rake db:create

echo ">>> Migrating..."
bundle exec rake db:migrate

if [ $RAILS_ENV = "development" ]
then
  echo ">>> Seed..."
  bundle exec rake db:seed
fi

# Then exec the container's main process (CMD).
exec "$@"