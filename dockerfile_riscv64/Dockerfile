FROM debian:trixie AS builder
LABEL authors="Alexandre Barros, Ana Luiza Mineiro, Arthur Pompeu"

USER root 
RUN dpkg --add-architecture riscv64 \
  && apt-get -y update \
  && apt-get -y install \
  build-essential \ 
  pkg-config  \
  cmake \
  autoconf \
  automake \
  libtool \
  gcc-riscv64-linux-gnu \ 
  g++-riscv64-linux-gnu \
  gfortran-riscv64-linux-gnu \
  gdb-multiarch \
  libopenblas-dev:riscv64 \
  liblapack-dev:riscv64 \
  libarpack2-dev:riscv64 \
  libsuperlu-dev:riscv64 \
  libarmadillo-dev:riscv64

FROM builder AS builder-lely-core
RUN mkdir /lely-core
COPY lely-core/ /lely-core
RUN mkdir /lely-core/build-riscv64-docker-debian-11
RUN mkdir /lely-core/install-riscv64-docker-debian-11
WORKDIR /lely-core
RUN autoreconf -i
RUN ./configure --host=riscv64-linux-gnu --disable-python --disable-tests --prefix=/lely-core/install-riscv64-docker-debian-11
RUN make -j8 
# -jT -> Onde T é a quantidade de Threads disponíveis no processador -> utilize o máximo para realizar o processo mais rápido
RUN make install

FROM builder AS builder-manopla
RUN mkdir -p /lely-core/install-riscv64-docker-debian-11
ENV PKG_CONFIG_PATH=/lely-core/install-riscv64-docker-debian-11/lib/pkgconfig
COPY --from=builder-lely-core /lely-core/install-riscv64-docker-debian-11 /lely-core/install-riscv64-docker-debian-11
ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash builder
USER builder