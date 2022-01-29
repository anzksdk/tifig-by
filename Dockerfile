FROM alpine as builder

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk --no-cache add \
    vips-dev@edge \
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



FROM alpine

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk --no-cache add \
    dumb-init \
    vips@edge \
    ffmpeg

WORKDIR /tifig
COPY --from=builder /tifig/build/tifig .

ENV PATH "${PATH}:/tifig"

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["tifig"]
