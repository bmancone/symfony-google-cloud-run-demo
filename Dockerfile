FROM composer:1.10 as build

WORKDIR /app

COPY composer.json composer.lock /app/

RUN composer global require hirak/prestissimo && \
    composer install --no-scripts --no-autoloader && \
    composer dump-autoload --optimize

FROM php:7.3-apache-stretch

ENV APACHE_RUN_USER app
ENV APACHE_RUN_GROUP app
ENV APACHE_PORT 8080

ENV APP_ENV prod

EXPOSE 8080

WORKDIR /var/www/app

RUN groupadd -g 1000 app && \
    useradd -u 1000 -ms /bin/bash -g app app

COPY docker/app.conf /etc/apache2/sites-available/
COPY --from=build --chown=app:app /app/vendor /var/www/app/vendor
COPY --chown=app:app . /var/www/app/

RUN echo "Listen $APACHE_PORT" > /etc/apache2/ports.conf && \
    echo "ServerSignature Off" >> /etc/apache2/apached2.conf && \
    echo "ServerTokens prod" >> /etc/apache2/apache2.conf && \
    echo "expose_php = Off" >> /usr/local/etc/php/php.ini && \
    a2enmod rewrite && \
    a2dissite 000-default && \
    a2ensite app

USER app

RUN php /var/www/app/bin/console cache:clear --no-warmup && \
    php /var/www/app/bin/console cache:warmup

CMD ["apache2-foreground"]