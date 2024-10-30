FROM alpine
LABEL authors="toxic0berliner"

# Set correct environment variables
ENV HOME="/duc"

# Install Dependencies
RUN apk add --no-cache --no-check-certificate\
        wget \
        git \
        bash \
        automake \
        autoconf \
        linux-headers \
        pkgconfig \
        apache2 \
        ncurses-dev \
        libncursesw \
        zlib \
        zstd \
        zstd-libs \
        gcompat \
        cairo-dev \
        pango-dev \
        build-base \
        kyotocabinet-dev && \
    cd /tmp && \
    wget https://dbmx.net/tkrzw/pkg/tkrzw-1.0.25.tar.gz &&\
    tar -xf tkrzw-1.0.25.tar.gz &&\
    cd /tmp/tkrzw-1.0.25 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf tkrzw


# Build duc
RUN mkdir /duc && \
    cd /duc && \
    git -c http.sslVerify=false clone https://github.com/zevv/duc.git &&\
    cd /duc/duc && \
    autoreconf -i && \
    autoupdate && \
    ./configure --disable-cairo --disable-ui --disable-x11 --with-db-backend=tkrzw && \ 
    make && \
    make install
ENV DUC_CGI_OPTIONS="--list --tooltip --dpi=120"

WORKDIR /duc