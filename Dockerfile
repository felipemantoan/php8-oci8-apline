FROM php:8.1.1-fpm-alpine3.14

# Defines OCI8 environment variables
ENV TNS_ADMIN       /opt/wallet
ENV ORACLE_BASE     /usr/lib/instantclient
ENV LD_LIBRARY_PATH /usr/lib/instantclient
ENV ORACLE_HOME     /usr/lib/instantclient
ENV NLS_LANG        'AMERICAN_AMERICA.AL32UTF8'
ENV NLS_DATE_FORMAT 'YYYY-MM-DD HH24:MI:SS'
ENV ORA_SDTZ        'UTC'

# Install php/oci8 libraries
RUN apk --no-cache add libaio libnsl libc6-compat curl ${PHPIZE_DEPS} && \
    # Browses to temporary directory
    cd /tmp && \
    # Downloads OCI library to compile driver
    curl -o /tmp/basic.zip https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-basic-linux.x64-19.14.0.0.0dbru.zip && \
    curl -o /tmp/sdk.zip https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-sdk-linux.x64-19.14.0.0.0dbru.zip && \
    curl -o /tmp/sqlplus.zip https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-sqlplus-linux.x64-19.14.0.0.0dbru.zip && \
    # Unzips all packages
    unzip -d /usr/local/ /tmp/basic.zip && \
    unzip -d /usr/local/ /tmp/sdk.zip && \
    unzip -d /usr/local/ /tmp/sqlplus.zip && \
    # Remove all files
    rm /tmp/basic.zip && \
    rm /tmp/sdk.zip && \
    rm /tmp/sqlplus.zip

# Creates symbolic links required per oci8 package
RUN ln -s /usr/local/instantclient_19_14 ${ORACLE_HOME} && \
    ln -s ${ORACLE_HOME}/lib* /usr/lib && \
    ln -s ${ORACLE_HOME}/sqlplus /usr/bin/sqlplus && \
    ln -s /usr/lib/libnsl.so.2.0.1 /usr/lib/libnsl.so.1 && \
    ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 && \
    ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2

RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/instantclient && \
    docker-php-ext-install oci8 && \
    docker-php-ext-enable oci8 && \
    sh -c "echo 'oci8.events = On' >> /usr/local/etc/php/conf.d/docker-php-ext-oci8.ini"
