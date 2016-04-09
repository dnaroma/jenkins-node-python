FROM debian:jessie

# prepare docker repo
RUN apt-get update \ 
    && apt-get install -y apt-transport-https ca-certificates \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && touch /etc/apt/sources.list.d/docker.list \
    && echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list
    
# install docker engine and start daemon, add jenkins user to docker group
RUN apt-get update \ 
    && apt-get install -y docker-engine \
    && gpasswd -a jenkins docker \
    
# install nodejs via nvm
RUN apt-get install -y build-essential libssl-dev \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash \
    && nvm install stable \
    && nvm use stable

# install python
RUN apt-get install -y python python3

# Add backports
RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list

# Update packages
RUN apt-get update && apt-get -y upgrade

# Install java
RUN apt-get -t jessie-backports install -y openjdk-8-jdk

# Install Git and OpenSSH
RUN apt-get install -y git openssh-server && mkdir /var/run/sshd

# Add user "jenkins" with password "jenkins"
RUN adduser --quiet jenkins && echo "jenkins:jenkins" | chpasswd

ENV CI=true
EXPOSE 22

ENTRYPOINT ["./entrypoint.sh"]
