FROM php:8.0-fpm-alpine3.13

# Defines OCI8 environment variables
ENV TNS_ADMIN       /opt/wallet
ENV ORACLE_BASE     /usr/lib/instantclient
ENV LD_LIBRARY_PATH /usr/lib/instantclient
ENV ORACLE_HOME     /usr/lib/instantclient

# Install php/oci8 libraries
RUN apk --no-cache add libaio libnsl libc6-compat curl ${PHPIZE_DEPS} && \
    # Browses to temporary directory
    cd /tmp && \
    # Downloads OCI library to compile driver
    curl -o /tmp/basic.zip https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip && \
    curl -o /tmp/sdk.zip https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip && \
    curl -o /tmp/sqlplus.zip https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip && \
    # Unzips all packages
    unzip -d /usr/local/ /tmp/basic.zip && \
    unzip -d /usr/local/ /tmp/sdk.zip && \
    unzip -d /usr/local/ /tmp/sqlplus.zip && \
    # Creates symbolic links required per oci8 package
    ln -s /usr/local/instantclient_21_1 ${ORACLE_HOME} && \
    ln -s ${ORACLE_HOME}/lib* /usr/lib && \
    ln -s ${ORACLE_HOME}/sqlplus /usr/bin/sqlplus && \
    ln -s /usr/lib/libnsl.so.2.0.0 /usr/lib/libnsl.so.1 && \
    ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 && \
    ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2 && \
    # Gets OCI8 package from pecl
    curl -o oci8-3.0.1.tgz https://pecl.php.net/get/oci8-3.0.1.tgz && \
    # Unzips package
    tar -zxf oci8-3.0.1.tgz && \
    cd oci8-3.0.1 && \
    phpize && \
    # IMPORTANT: Configure OCI8 to use instant client
    ./configure --with-oci8=instantclient,/usr/lib/instantclient && \
    # Installs/Enables driver
    make install && \
    docker-php-ext-enable oci8
