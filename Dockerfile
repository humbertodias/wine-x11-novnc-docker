#FROM phusion/baseimage
FROM i386/debian:buster
MAINTAINER archedraft

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /config nobody && \
 chown -R nobody:users /home

RUN apt update && apt -y install xvfb x11vnc xdotool software-properties-common gnupg apt-transport-https net-tools fluxbox xfonts-base xterm cabextract wget supervisor
RUN wget -qnc https://dl.winehq.org/wine-builds/Release.key && apt-key add Release.key && apt-key add Release.key && apt -y install wine
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN chmod +x /usr/local/bin/winetricks

ENV WINEPREFIX /root/prefix32
ENV WINEARCH win32
ENV DISPLAY :0

WORKDIR /root/
ADD novnc /root/novnc/

# Expose Port
EXPOSE 8080 5900

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]