#!/bin/bash

# Loading ENV variables
set -a
source ci/docker/.env.testing
set +a

echo "Copying main plugin files as a pre-build (excluding .stage, ci, ..)"

rsync -av \
  --exclude='.stage' \
  --exclude='ci' \
  --exclude='.git' \
  --exclude='.*' \
  --exclude='*.md' \
  --exclude='*.lock' \
  --exclude='*.sh' \
  --delete-after \
  ./ ./ci/docker/tmp_build/

# Remove redundant files
rm -f ./ci/docker/tmp_build/.phpunit.result.cache ./ci/docker/tmp_build/composer.lock

# # install deps
composer install --working-dir=./ci/docker/tmp_build/

# start services
docker compose --env-file ci/docker/.env.testing -f ci/docker/compose.yml down --remove-orphans
docker compose --env-file ci/docker/.env.testing -f ci/docker/compose.yml up -d \
  --build --remove-orphans \
  --renew-anon-volumes # removes old anonymous volumes attached to containers


echo "Waiting for database container to get ready..."
while ! docker compose -f ci/docker/compose.yml  exec database mysqladmin --user=root --password=$DB_ROOT_PASSWORD --host "127.0.0.1" ping --silent &> /dev/null ; do
    sleep 1
done


echo "Setting WP login user .."
docker compose -f ci/docker/compose.yml exec wordpress wp core install --path="/var/www/html" --url="http://127.0.0.1:$APP_PORT" --title="WP Local" --admin_user="$WP_USER" --admin_password="$WP_PASS" --admin_email="$WP_EMAIL" --allow-root

# Activate the plugin
docker compose -f ci/docker/compose.yml exec wordpress wp plugin activate $WP_PLUGIN_SLUG --path="/var/www/html" --url="http://127.0.0.1:$APP_PORT" --allow-root

# Run tests
docker compose -f ci/docker/compose.yml exec -w /var/www/html/wp-content/plugins/$WP_PLUGIN_SLUG wordpress ./vendor/bin/phpunit


# Copying phpunit report from container to an accessible path for developer
mkdir -p ./.stage/reports
docker compose -f ci/docker/compose.yml cp wordpress:/var/www/html/wp-content/plugins/$WP_PLUGIN_SLUG/reports/phpunit.xml ./.stage/reports/phpunit-report.xml

# Test by plugin-check
docker compose --env-file ci/docker/.env.testing -f ci/docker/compose.yml exec wordpress wp plugin install  plugin-check --allow-root
docker compose --env-file ci/docker/.env.testing -f ci/docker/compose.yml exec wordpress wp plugin activate plugin-check --allow-root
docker compose --env-file ci/docker/.env.testing -f ci/docker/compose.yml \
  exec wordpress wp plugin check $WP_PLUGIN_SLUG \
  --exclude-directories=ci,.stage \
  --format=table \
  --exclude-files=.* \
  --allow-root > ./.stage/reports/plugin-check-report.md

cat ./.stage/reports/plugin-check-report.md

URL="http://127.0.0.1:${APP_PORT}/wp-admin/"

echo ""
echo "Setup completed."
