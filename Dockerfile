# FROM alpine
FROM debian:12
LABEL authors="toxic0berliner"

# Set correct environment variables
ENV HOME /duc

RUN apt-get update -qq && \ 
    apt-get install -qq wget apache2 libncursesw5-dev libcairo2-dev libpango1.0-dev build-essential libtkrzw-dev git autoconf automake && \ 
    apt-get autoremove && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

ARG git_user
ARG git_pass
ENV GIT_USERNAME $git_user
ENV GIT_PASSWORD $git_pass

# Install duc
# /duc/db is a directory to mount multiple DBs, for server. duc_startup.sh look into this directory and create CGIs
RUN mkdir /duc && \
    mkdir /duc/db && \ 
    cd /duc && \
    git -c http.sslVerify=false clone https://${GIT_USERNAME}:${GIT_PASSWORD}@gitlab.amato.top/dev/duc.git &&\
    cd /duc/duc && \
    autoreconf -i && \
    ./configure && \ 
    make && \
    make install && \
    cd .. && \
    rm -rf duc

COPY assets/000-default.conf /etc/apache2/sites-available/
COPY assets/ducrc /etc/
COPY assets/duc_startup.sh /duc/

#create a starter database so that we can set permissions for cgi access
RUN mkdir /var/www/duc && \
    mkdir /host && \
	chmod 777 /duc/ && \
    duc index /host/ && \
	chmod 777 /duc/.duc.db && \
	a2enmod cgi && \
	chmod +x /duc/duc_startup.sh

ENV DUC_CGI_OPTIONS --list --tooltip --dpi=120
EXPOSE 80

WORKDIR /duc
CMD /duc/duc_startup.sh
