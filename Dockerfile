# source Image
FROM ubuntu:20.04

# set noninterative mode
ENV DEBIAN_FRONTEND noninteractive

# apt-get update and install global requirements
RUN touch /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99fixbadproxy \
    && echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update -y \
    && apt-get upgrade -y && \
    apt-get install -y  \
        autoconf \
        autogen \
        build-essential \
        curl \
        libbz2-dev \
        libcurl4-openssl-dev \
        libhts3 \
        libhts-dev \
        liblzma-dev \
        libncurses5-dev \
        libnss-sss \
        libssl-dev \
        libxml2-dev \
        ncbi-blast+ \
        r-base \
        r-bioc-biostrings \
        r-bioc-rsamtools \
        r-cran-biocmanager \
        r-cran-devtools \
        r-cran-stringr \
        r-cran-optparse \
        zlib1g-dev

# apt-get clean and remove cached source lists
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install global r requirements
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "library(devtools); install_github('mhahsler/rBLAST')"

# install scramble
COPY . /app
RUN cd /app/cluster_identifier/src && \
  make
RUN ln -s /app/cluster_identifier/src/build/cluster_identifier /usr/local/bin

# define default command
CMD ["Rscript"]
