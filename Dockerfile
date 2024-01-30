FROM ubuntu:23.04
LABEL maintainer "Ridwan Shariffdeen <rshariffdeen@gmail.com>"
# dependecies from infer dockerfile
RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install --yes --no-install-recommends \
      curl \
      gpg-agent \
      libc6-dev \
      openjdk-11-jdk-headless \
      sqlite3 \
      xz-utils \
      zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# install opam
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends software-properties-common \
        build-essential \
        patch \
        git && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends opam

# install opam system-level dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    autoconf \
    libgmp-dev \
    libsqlite3-dev \
    pkg-config \
    automake \
    cmake \
    clang \
    python3 \
    python3-distutils \
    libmpfr-dev

# Download the latest Infer from git
RUN cd /opt && \
    git clone --depth 1 https://github.com/facebook/infer/


# really building infer
# See https://bugs.llvm.org/show_bug.cgi?id=51359 on why clang is needed instead of gcc
WORKDIR /opt/infer/
ENV CC clang
ENV CXX clang++
RUN ./build-infer.sh -y clang
ENV PATH /opt/infer/infer/bin:${PATH}
