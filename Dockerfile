FROM ubuntu:16.04
MAINTAINER Sujit Mathew <sujmat@gmail.com>
WORKDIR /build
#ENV for build TAG
ARG BUILD_TAG
ENV BUILD_TAG ${BUILD_TAsG:-master}
RUN echo "Build tag:" $BUILD_TAG
# install tools and dependencies
RUN apt-get update && \
        apt-get install -y --force-yes --no-install-recommends \
        # make
        build-essential \
        # add-apt-repository
        software-properties-common \
        make \
        curl \
        wget \
        git \
        g++ \
        gcc \
        libc6 \
        libc6-dev \
        binutils \
        file \
        openssl \
        libssl-dev \
        libudev-dev \
        pkg-config \
        dpkg-dev \
        npm \
        libudev-dev &&\
# install rustup
 curl https://sh.rustup.rs -sSf | sh -s -- -y && \
# rustup directory
 PATH=/root/.cargo/bin:$PATH && \
# show backtraces
 RUST_BACKTRACE=1 && \
# build parity
cd /build&&git clone https://github.com/energywebfoundation/energyweb-client && \
        cd energyweb-client && \
	git pull&& \
	git checkout $BUILD_TAG && \
        cargo build --verbose --release --features final && \
        #ls /build/energyweb-client/target/release/parity && \
        strip /build/energyweb-client/target/release/parity && \
 file /build/energyweb-client/target/release/parity&&mkdir -p /parity&& cp /build/energyweb-client/target/release/parity /parity&&\
#cleanup Docker image
 rm -rf /root/.cargo&&rm -rf /root/.multirust&&rm -rf /root/.rustup&&rm -rf /build&&\
 apt-get purge -y  \
        # make
        build-essential \
        # add-apt-repository
        software-properties-common \
        make \
        curl \
        wget \
        git \
        g++ \
        gcc \
        binutils \
        file \
        pkg-config \
        dpkg-dev &&\
 rm -rf /var/lib/apt/lists/*

# setup ENTRYPOINT
EXPOSE 8080 8545 8180
ENTRYPOINT ["/parity/parity"]
