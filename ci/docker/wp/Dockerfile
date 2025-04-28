# Declare a build argument
ARG WORDPRESS_TAG=6-php8.3-apache

# Use the build argument in the FROM line
FROM wordpress:${WORDPRESS_TAG}

# Declare a plugin slug argument
ARG WP_PLUGIN_SLUG=wp-unit-test

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy wp-cli binary from the build stage
COPY --from=wordpress:cli /usr/local/bin/wp /usr/local/bin/wp

# Add WP CLI config
COPY wp/wp-cli.yml /var/www/html/wp-cli.yml

RUN chown -R www-data:www-data /var/www/html
