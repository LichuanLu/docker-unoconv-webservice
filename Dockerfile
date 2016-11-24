#######################################################################
# Dockerfile for using unoconv through a webservice for Chinese fonts
#######################################################################

# Setting the base to nodejs 4.6.0
FROM node:4.6.0-slim

# Maintainer
MAINTAINER Lichuan Lu

#### Begin setup ####

# Installs git and unoconv
RUN echo "==> Upgrade source" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y upgrade && \
    \
    echo "==> Install Unoconv" && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y unoconv imagemagick && \
    \
    echo "==> Install supervisor" && \
    apt-get install -y supervisor && \
    \
    echo "==> Install Fonts" && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core \
    language-pack-zh-hant \
    ttf-wqy-zenhei && \
    \
    echo "==> Clean up" && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists


# COPY files
COPY unoconv.conf /etc/supervisor/conf.d/unoconv.conf
COPY restart.sh /restart.sh

# Clone the repo
RUN git clone https://github.com/zrrrzzt/tfk-api-unoconv.git unoconvservice

# Change working directory
WORKDIR "/unoconvservice"

# Install dependencies
RUN npm install --production

# Env variables
ENV SERVER_PORT 3000
ENV PAYLOAD_MAX_SIZE 10485760
ENV LC_ALL zh_CN.UTF-8

# Expose 3000
EXPOSE 3000

# Startup
CMD ["/usr/bin/supervisord"]
