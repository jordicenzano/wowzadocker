# Generate a docker with wowza 4.2.0 & SSH
# by Jordi Cenzano
# VERSION               1.0.0

FROM ubuntu:14.04
MAINTAINER jordi.cenzano@gmail.com

#Update
RUN apt-get update
RUN apt-get upgrade -y

#Install packages
RUN apt-get install ssh -y
RUN apt-get install supervisor -y

#Create volume data
VOLUME ["/data"]

#Copy script wowza installation (only installs wowza if detects wowza is not in the system)
COPY scripts/wowzainstall.sh /iniscripts/wowzainstall.sh
RUN chmod 755 /iniscripts/wowzainstall.sh
#TODO:RUN /iniscripts/wowzainstall.sh #We need a silence installation method (provided by wowza)

#Expose wowza ports + SSH
EXPOSE 22
EXPOSE 1935
EXPOSE 8086
EXPOSE 8087
EXPOSE 8088

#Create user deploy (TODO: Improve passing pass in some smart way)
#adduser.sh: useradd -m -s /bin/bash -p $(openssl passwd -1 -salt xyz SOMESMARTPASS) USERNAME
COPY creds/adduser.sh /tmp/adduser.sh
RUN chmod 755 /tmp/adduser.sh
RUN /tmp/adduser.sh
RUN rm /tmp/adduser.sh

#Install ssh as a service
COPY scripts/sshinstall.sh /iniscripts/sshinstall.sh
RUN chmod 755 /iniscripts/sshinstall.sh
RUN /iniscripts/sshinstall.sh

#TODO: Deactivate root ssh access

#Execute all following commands as deploy
USER deploy

#Copy ssh pub key for deploy
RUN mkdir /home/deploy/.ssh
COPY creds/wowzadocker.pub /home/deploy/.ssh/authorized_keys

#Start ssh services ssh, wowzaengine, wowzamanager
USER root
COPY scripts/start.sh /iniscripts/start.sh
RUN chmod 755 /iniscripts/start.sh
ENTRYPOINT exec /iniscripts/start.sh