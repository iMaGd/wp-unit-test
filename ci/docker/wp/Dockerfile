# Declare a build argument
ARG WORDPRESS_BASE_IMAGE=6-php8.3-apache

# Use the build argument in the FROM line
FROM ${WORDPRESS_BASE_IMAGE}

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy wp-cli binary from the build stage
COPY --from=wordpress:cli /usr/local/bin/wp /usr/local/bin/wp

# Add WP CLI config
COPY wp/wp-cli.yml /var/www/html/wp-cli.yml

# Apply proper ownership
RUN chown -R www-data:www-data /var/www/html
