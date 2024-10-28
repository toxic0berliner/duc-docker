FROM alpine
LABEL authors="toxic0berliner"

# Set correct environment variables
ENV HOME /duc

# Install Dependencies
RUN apk add --no-cache --no-check-certificate\
        wget \
        git \
        rsync \
        bash \
        automake \
        autoconf \
        linux-headers \
        pkgconfig \
        apache2 \
        ncurses-dev \
        libncursesw \
        zlib \
        cairo-dev \
        pango-dev \
        build-base \
        kyotocabinet-dev && \
    cd /tmp && \
    git -c http.sslVerify=false clone https://github.com/estraier/tkrzw.git &&\
    cd /tmp/tkrzw && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf tkrzw


# Install duc
# /duc/db is a directory to mount multiple DBs, for server. duc_startup.sh look into this directory and create CGIs
RUN mkdir /duc && \
    mkdir /duc/db && \ 
    cd /duc && \
    git -c http.sslVerify=false clone https://github.com/zevv/duc.git &&\
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
