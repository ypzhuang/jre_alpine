FROM alpine:3.14

MAINTAINER John <zhuangyinping@gmail.com>

ENV GLIBC_VERSION=2.34-r0 \
    LANG=C.UTF-8 \
    JDK_VERSION=jre1.8.0_202 \
    JDK_ZIP=jre-8u202-linux-x64.tar.gz

RUN apk upgrade --update && \    
    apk add --update tzdata libstdc++ openssl curl ca-certificates wget && \
    rm -rf /var/cache/apk/*

ENV TZ=Asia/Shanghai

RUN echo "install third party from bitbucket "


RUN wget "https://bitbucket.org/john_zhuang_team/jdk_on_linux/raw/dc2b710bb58938b44192b5b8d99063536ead503c/$JDK_ZIP" \
    -O /$JDK_ZIP

RUN for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib
# RUN apk del curl

ADD . /

RUN mkdir -p /opt
RUN tar xvf /$JDK_ZIP  -C /opt  \
    && ln -s /opt/$JDK_VERSION/bin/java /usr/bin/java \
    && rm /$JDK_ZIP


ENV JAVA_HOME /opt/$JDK_VERSION/
RUN java -version

RUN sed -i 's/https/http/' /etc/apk/repositories

RUN apk add --update fontconfig mkfontscale && \
    rm -rf /var/cache/apk/*

RUN apk --no-cache add wqy-zenhei --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    fc-cache -f && \
    fc-list









