FROM ubuntu:17.04

MAINTAINER Atsushi Eno <atsushieno@gmail.com>

# General preparation

RUN mkdir /sources
RUN mkdir /logs

# Xamarin.Android prerequisites (copied from xamarin-android/Dockerfile)

ENV PATH=/usr/local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

RUN apt-get install dirmngr
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list
RUN echo "deb http://download.mono-project.com/repo/debian alpha main" | tee /etc/apt/sources.list.d/mono-xamarin-alpha.list
RUN apt-get update >/logs/apt-get-update.log 2>/logs/apt-get-update.log

RUN echo y | apt install curl openjdk-8-jdk git make automake autoconf libtool unzip vim-common clang nuget referenceassemblies-pcl lib32stdc++6 lib32z1 libzip4
# RUN echo y | apt install mono-xbuild
RUN echo y | apt install g++ cmake

# Mono Runtime
RUN cd /sources && git clone https://github.com/mono/mono.git --recursive
RUN cd /sources/mono && git pull && ./autogen.sh --disable-nls && make >/logs/mono-build.log 2>/logs/mono-build.log && make install >/logs/mono-install.log 2>/logs/mono-install.log

RUN cd /sources && git clone https://github.com/mono/gtk-sharp.git -b gtk-sharp-2-12-branch --recursive
RUN echo y | apt install libtool libtool-bin pkg-config libglade2-dev >/logs/prerequisites-setup-2.log 2>/logs/prerequisites-setup-2.log
RUN cd /sources/gtk-sharp && ./bootstrap-2.12 && make >/logs/gtk-sharp-build.log 2>/logs/gtk-sharp-build.log && make install >/logs/gtk-sharp-install.log 2>/logs/gtk-sharp-install.log

# MSBuild
RUN echo y | apt install libunwind8
RUN cd /sources && git clone https://github.com/mono/msbuild.git --recursive -b xplat-master
RUN cd /sources/msbuild && ./cibuild.sh --host Mono --target Mono && ./install-mono-prefix.sh /usr/local

# F#
RUN cd /sources && git clone https://github.com/fsharp/fsharp.git --recursive
RUN cd /sources/fsharp && git pull && ./autogen.sh && make && make install

# MonoDevelop
RUN cd /sources && git clone https://github.com/mono/monodevelop.git --recursive
RUN echo y | apt install libssh2-1-dev libssh-dev
RUN cd /sources/monodevelop && git pull && ./configure && make && make install

# Xamarin.Android
RUN cd /sources && git clone https://github.com/xamarin/xamarin-android.git
RUN cd /sources/xamarin-android && git submodule init
RUN cd /sources/xamarin-android && git submodule update external/mono
RUN cd /sources/xamarin-android/external/mono && git submodule init
RUN cd /sources/xamarin-android/external/mono && git submodule update external/referencesource
RUN cd /sources/xamarin-android/external/mono && git submodule update --init --recursive
RUN cd /sources/xamarin-android && make prepare
RUN cd /sources/xamarin-android && make


