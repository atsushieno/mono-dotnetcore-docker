FROM ubuntu:16.04

MAINTAINER Atsushi Eno <atsushieno@gmail.com>

# General preparation

RUN mkdir /sources

# On Ubuntu 17.04 dirmngr is required before running apt-key... and to get it apt-get update is required...
RUN apt-get update
RUN echo y | apt install dirmngr

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list
RUN echo "deb http://download.mono-project.com/repo/debian alpha main" | tee /etc/apt/sources.list.d/mono-xamarin-alpha.list
RUN apt-get update

# mono prerequisites
RUN echo y | apt install curl openjdk-8-jdk git make automake autoconf libtool unzip vim-common clang nuget referenceassemblies-pcl lib32stdc++6 lib32z1 libzip4 g++ cmake
# gtk-sharp prerequisites
RUN echo y | apt install libtool libtool-bin pkg-config libglade2-dev
# msbuild prerequisites
RUN echo y | apt install libunwind8
# monodevelop prerequisites
RUN echo y | apt install libssh2-1-dev libssh-dev

# source checkouts
RUN cd /sources && git clone https://github.com/mono/mono.git --recursive
RUN cd /sources && git clone https://github.com/mono/gtk-sharp.git -b gtk-sharp-2-12-branch --recursive
RUN cd /sources && git clone https://github.com/mono/msbuild.git --recursive -b xplat-master
RUN cd /sources && git clone https://github.com/fsharp/fsharp.git --recursive
RUN cd /sources && git clone https://github.com/mono/monodevelop.git --recursive
RUN cd /sources && git clone https://github.com/xamarin/xamarin-android.git --recursive

RUN cd /sources && git clone https://github.com/dotnet/coreclr.git --recursive
RUN cd /sources && git clone https://github.com/dotnet/corefx.git --recursive
RUN cd /sources && git clone https://github.com/dotnet/cli.git --recursive
RUN cd /sources && git clone https://github.com/dotnet/roslyn.git --recursive
RUN cd /sources && git clone https://github.com/Microsoft/msbuild.git msbuild-ms --recursive
