FROM alpine:3.15 as builder

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk --no-cache add \
    vips-dev \
    ffmpeg-dev \
    fftw-dev \
    g++ \
    cmake \
    make

ADD . /tifig

RUN \
 mkdir /tifig/build &&\
 cd /tifig/build &&\
 cmake .. &&\
 make -j



FROM alpine:3.15

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk --no-cache add \
    dumb-init \
    vips \
    ffmpeg

WORKDIR /tifig
COPY --from=builder /tifig/build/tifig .

ENV PATH "${PATH}:/tifig"

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["tifig"]
