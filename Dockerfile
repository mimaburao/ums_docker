FROM debian:stretch

# install packages per https://github.com/UniversalMediaServer/UniversalMediaServer/wiki/Linux-install-instructions
RUN (dpkg --add-architecture i386 &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y dcraw flac libfreetype6:i386 libstdc++6:i386 libbz2-1.0:i386 lib32z1 lib32ncurses5 mediainfo mencoder mplayer vlc wget &&\
  rm -rf /var/lib/apt/lists/*)

#japanese T.Yazawa 03-22-2019
ENV DEBIAN_FRONTEND noninteractive

RUN (apt-get update)
RUN (apt-get install -y locales)

RUN (echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=ja_JP.UTF-8)

ENV LC_ALL ja_JP.UTF-8

ENV UMS_PROFILE /opt/ums/UMS.conf

# get latest release number and use that to install UMS; fail to install if version is not 8.x
#UMS_9.4.1version update 2020-04-14
RUN (wget --content-disposition 'https://sourceforge.net/projects/unimediaserver/files/9.4.1/UMS-9.4.1.tgz/download' -O /opt/UMS-9.4.1.tgz &&\
  cd /opt &&\
  tar xzf UMS-9.4.1.tgz &&\
  rm UMS-9.4.1.tgz &&\
  mv ums-9.4.1 ums &&\
  mkdir /opt/ums/database /opt/ums/data &&\
  groupadd -g 500 ums &&\
  useradd -u 500 -g 500 -d /opt/ums ums &&\
  chown -R ums:ums /opt/ums)

USER ums
WORKDIR /opt/ums
EXPOSE 1900/udp 2869 5001 9001
ENV JVM_OPTS=-Xmx512M
CMD java $JVM_OPTS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap \
	-DUMS_PROFILE=/profile -Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djna.nosys=true \
	-cp ums.jar net.pms.PMS
VOLUME ["/tmp","/opt/ums/database","/opt/ums/data"]
CMD ["/opt/ums/UMS.sh"]
