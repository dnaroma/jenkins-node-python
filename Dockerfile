FROM jenkins

# prepare docker repo
RUN apt-get purge -y lxc-docker* \
    && apt-get purge -y docker.io* \
    && apt-get update \
    && apt-get install -y apt-transport-https ca-certificates \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && touch /etc/apt/sources.list.d/docker.list \
    && echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list
    && apt-get update
    
# install docker engine and start daemon, add jenkins user to docker group
RUN apt-get install docker-engine \
    && groupadd docker \
    && gpasswd -a jenkins docker \
    && service docker start
    
# install nodejs via nvm
RUN apt-get install -y build-essential libssl-dev \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash \
    && nvm install stable \
    && nvm use stable

# install python
RUN apt-get install -y python python3
