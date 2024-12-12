FROM debian:11 AS builder
LABEL authors="Alexandre Barros, Ana Luiza Mineiro, Arthur Pompeu"

USER root 
RUN apt -y update 
RUN apt -y install build-essential \
  pkg-config \
  cmake \
  autoconf \
  automake \
  libtool \
  gcc \
  g++ \
  gdb \
  libopenblas-base \
  liblapack3 \
  libarpack2 \
  libsuperlu5 \
  libarmadillo-dev 

FROM builder AS builder-lely-core
RUN mkdir /lely-core
COPY lely-core/ /lely-core
RUN mkdir /lely-core/build-x86_64-docker-debian-11
RUN mkdir /lely-core/install-x86_64-docker-debian-11
WORKDIR /lely-core
RUN autoreconf -i
RUN ./configure --disable-python --disable-tests --prefix=/lely-core/install-x86_64-docker-debian-11
RUN make -j8 
# -jT -> Onde T é a quantidade de Threads disponíveis no processador -> utilize o máximo para realizar o processo mais rápido
RUN make install

FROM builder AS builder-manopla
RUN mkdir -p /lely-core/install-x86_64-docker-debian-11
ENV PKG_CONFIG_PATH=/lely-core/install-x86_64-docker-debian-11/lib/pkgconfig
COPY --from=builder-lely-core /lely-core/install-x86_64-docker-debian-11 /lely-core/install-x86_64-docker-debian-11
ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash builder
USER builder
