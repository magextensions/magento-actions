FROM debian:stretch

RUN apt-get -y update \
    && apt-get -y install \
    apt-transport-https \
    ca-certificates \
    wget

RUN wget -O "/etc/apt/trusted.gpg.d/php.gpg" "https://packages.sury.org/php/apt.gpg" \
    && sh -c 'echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list'

RUN apt-get -y update \
    && apt-get -y install \
    git \
    curl \
    php7.1-cli \
    php7.1-curl \
    php7.1-dev \
    php7.1-gd \
    php7.1-intl \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-mbstring \
    php7.1-xml \
    php7.1-xsl \
    php7.1-zip \
    php7.1-json \
    php7.1-soap \
    php7.1-bcmath \
    php7.2 \
    php7.2-common \
    php7.2-cli \
    php7.2-curl \
    php7.2-dev \
    php7.2-gd \
    php7.2-intl \
    php7.2-mysql \
    php7.2-mbstring \
    php7.2-xml \
    php7.2-xsl \
    php7.2-zip \
    php7.2-json \
    php7.2-xdebug \
    php7.2-soap \
    php7.2-bcmath \
    php7.4 \
    php7.4-common \
    php7.4-cli \
    php7.4-curl \
    php7.4-dev \
    php7.4-gd \
    php7.4-intl \
    php7.4-mysql \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-xsl \
    php7.4-zip \
    php7.4-json \
    php7.4-xdebug \
    php7.4-soap \
    php7.4-bcmath \
    zip \
    symlinks \
    mysql-client \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

RUN curl -LO https://getcomposer.org/composer-stable.phar \
    && mv ./composer-stable.phar ./composer.phar \
    && chmod +x ./composer.phar \
    && mv ./composer.phar /usr/local/bin/composer

#Composer back to version 1
RUN composer selfupdate --1

# Add node 10.x repository
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# apt-get update is called by node setup script already
RUN apt-get install --no-install-recommends -y \
    nodejs

#Install Megapack
RUN apt-get update \
     && apt-get install -y wget gnupg ca-certificates \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-stable chromium \
     && rm -rf /var/lib/apt/lists/*

RUN npm install -g magepack --unsafe-perm=true --allow-root
#End Install Megapack

#Install Yarn
# Add yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# Add node 10.x repository
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# apt-get update is called by node setup script already
RUN apt-get install --no-install-recommends -y \
    nodejs \
    yarn
#End install yarn

RUN npm install -g gulp
#RUN npm link gulp

#CMD ["/bin/bash"]


COPY LICENSE README.md /
COPY scripts /opt/scripts
COPY config /opt/config
COPY entrypoint.sh /entrypoint.sh

RUN cd /opt/config/php-deployer/ && composer install

ENTRYPOINT ["/entrypoint.sh"]
