FROM dunglas/frankenphp AS base

RUN install-php-extensions \
	pdo_mysql \
	gd \
	intl \
	zip \
	opcache \
	redis \
	pcntl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV SERVER_NAME=:80
FROM base AS production

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY . /app