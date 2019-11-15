FROM ubuntu:trusty
MAINTAINER jeanpul <contact@codeffekt.com>

RUN apt-get update; apt-get clean

RUN apt-get install -y wget

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chrome.
RUN apt-get update && apt-get -y install google-chrome-stable

RUN apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

# Install node
RUN curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n && chmod +x /usr/local/bin/n && n 12.4.0

# Install docker ce
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

RUN useradd -rm -d /home/jeanpul -s /bin/bash -g root -G docker,sudo -u 1000 jeanpul

# USER jeanpul
WORKDIR /home/jeanpul

ENTRYPOINT ["entrypoint.sh", "sudo", "su", "jeanpul"]
