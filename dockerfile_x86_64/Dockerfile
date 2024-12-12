FROM debian:11 AS builder
LABEL authors="grilo"

USER root 
RUN apt -y update 
RUN apt -y install build-essential 
RUN apt -y install  pkg-config 
RUN apt -y install  cmake 
RUN apt -y install  autoconf 
RUN apt -y install  automake 
RUN apt -y install  libtool 
RUN apt -y install  gcc 
RUN apt -y install  g++ 
RUN apt -y install  gdb  
RUN apt -y install  libopenblas-base
RUN apt -y install  liblapack 
RUN apt -y install  libarpack2 
RUN apt -y install  libsuperlu 
RUN apt -y install  libarmadillo

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
