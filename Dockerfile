# BigBlueButton - 0.81
# 
# VERSION   1.0
FROM    ubuntu:10.04
ENV     DEBIAN_FRONTEND noninteractive

RUN     echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" | tee -a /etc/apt/sources.list
RUN     apt-get --yes --force-yes update
RUN     apt-get --yes --force-yes upgrade 
RUN     apt-get --yes install wget language-pack-en

# Setup locale
RUN     locale-gen en_US.UTF-8
RUN     update-locale LANG=en_US.UTF-8
ENV     LANG en_US.UTF-8

# BigBlueButton add-apt-repository
RUN     wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | apt-key add -
RUN     echo "deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-lucid main" | tee /etc/apt/sources.list.d/bigbluebutton.list
RUN     apt-get --yes --force-yes update

# LibreOffice
RUN     wget http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb
RUN     dpkg -i openoffice.org_1.0.4_all.deb

RUN     apt-get --yes --force-yes install python-software-properties
RUN     apt-add-repository ppa:libreoffice/libreoffice-4-0
RUN     apt-get --yes update
RUN     apt-get --yes --force-yes install libreoffice-common
RUN     apt-get --yes --force-yes install libreoffice

# Ruby
RUN     apt-get --yes --force-yes install libreadline5 libyaml-0-2 libffi5
RUN     wget https://bigbluebutton.googlecode.com/files/ruby1.9.2_1.9.2-p290-1_amd64.deb
RUN     dpkg -i ruby1.9.2_1.9.2-p290-1_amd64.deb
RUN     apt-get --yes --force-yes install -f
RUN     update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.2 500 \
                         --slave /usr/bin/ri ri /usr/bin/ri1.9.2 \
                         --slave /usr/bin/irb irb /usr/bin/irb1.9.2 \
                         --slave /usr/bin/erb erb /usr/bin/erb1.9.2 \
                         --slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.2
RUN     update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.2 500

# FFMpeg
RUN     apt-get --yes --force-yes install build-essential git-core checkinstall yasm \
                                        texi2html libvorbis-dev libx11-dev libxfixes-dev \
                                        zlib1g-dev pkg-config
ENV     LIBVPX_VERSION  1.2.0
ENV     FFMPEG_VERSION  2.0.1

RUN     git clone http://git.chromium.org/webm/libvpx.git /usr/local/src/"libvpx-${LIBVPX_VERSION}" && \
        cd /usr/local/src/"libvpx-${LIBVPX_VERSION}" && \
        git checkout "v${LIBVPX_VERSION}" && \
        ./configure && \
        make && \
        checkinstall --pkgname=libvpx --pkgversion="${LIBVPX_VERSION}" --backup=no --deldoc=yes --default

RUN     cd /usr/local/src && \
        wget "http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2" && \
        tar -xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2" && \
        cd "ffmpeg-${FFMPEG_VERSION}" && \
        ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx && \
        make && \
        checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default

# BigBlueButton
RUN     apt-get --yes --force-yes install libavcodec52 libavformat52 libavutil49 libbind9-60 libcaca0 libcdparanoia0       \ 
            libcommons-collections-java libcommons-daemon-java libcommons-dbcp-java libcommons-pool-java libcupsimage2     \
            libcurl3 libcurl4-openssl-dev libdjvulibre-text libdjvulibre21 libdns64 libdvdnav4 libdvdread4 libecj-java     \
            libenca0 libesd0 libexpat1-dev libfontconfig1-dev libfreetype6-dev libgd2-noxpm libgeoip1 libgl1-mesa-dri      \
            libgl1-mesa-glx libgpm2 libgraphviz4 libgs8 libgsm1 libgssrpc4 libidn11-dev libilmbase6 libisc60 libisccc60    \
            libisccfg60 libjack0 libjpeg62-dev libkadm5clnt-mit7 libkadm5srv-mit7 libkdb5-4 libkrb5-dev libldap2-dev       \
            liblircclient0 libltdl7 liblwres60 liblzo2-2 libmagickcore2 libmagickcore2-extra libmagickwand2 libmp3lame0    \
            libmpcdec3 liboil0.3 libopenal1 libopenexr6 libpostproc51 libsamplerate0 libschroedinger-1.0-0 libsdl1.2debian \
            libsdl1.2debian-alsa libsmbclient libsox-fmt-alsa libsox-fmt-base libsox1a libspeex1 libssl-dev libsvga1       \
            libswscale0 libt1-5 libtalloc2 libtheora0 libtomcat6-java libwavpack1 libwbclient0 libwmf0.2-7 libx264-85      \
            libx86-1 libxml2-dev libxslt1-dev libxv1 libxvidcore4 libxvmc1 libxxf86dga1 libxxf86vm1
RUN     apt-get --yes --force-yes install authbind  gsfonts-x11 imagemagick libaa1 libao2 libaudio2 mencoder mplayer odbcinst \
            odbcinst1debian1 red5 redis-server-2.2.4 sox swftools-0.9.1 tomcat6 tomcat6-common unixodbc unzip vorbis-tools    \
            xpdf-common xpdf-utils zip
RUN     apt-get --yes --force-yes install bbb-web
# RUN     apt-get --yes --force-yes install bigbluebutton
