FROM ubuntu:trusty
MAINTAINER jeanpul <contact@codeffekt.com>

RUN apt-get update; apt-get clean

RUN apt-get install -y wget

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chrome.
RUN apt-get update && apt-get -y install google-chrome-stable

# Install node
RUN wget -qO- https://deb.nodesource.com/setup_12.4 | sudo -E bash - \
    && apt-get install -y nodejs

# Install docker ce
RUN apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

RUN apt-get update && apt-get install -y docker-ce

# Install docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
