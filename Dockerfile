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
#UMS_10over 2021-08-19
#UMS10.12 2021-10-20
RUN (UMSVER=$(wget -q -O - https://api.github.com/repos/UniversalMediaServer/UniversalMediaServer/releases/latest | python -c "import sys, json; print json.load(sys.stdin)['name']") &&\
  if [ "$(echo $UMSVER | awk -F '.' '{print $1}')" -ne "10" ]; then echo "Latest version number is no longer 10"; exit 1; fi &&\
  wget --content-disposition "http://sourceforge.net/projects/unimediaserver/files/${UMSVER}/UMS-${UMSVER}-x86_64.tgz/download" -O /opt/UMS-${UMSVER}.tgz &&\
  cd /opt &&\
  tar zxf UMS-${UMSVER}.tgz &&\
  rm UMS-${UMSVER}.tgz &&\
  mv ums-${UMSVER} ums &&\
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
