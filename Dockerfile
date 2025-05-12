FROM ubuntu:24.10

RUN apt update

RUN apt install vim git gdb gcc make python3 python3-pip \
    terminator qemu-user gdb-multiarch checksec ltrace \
    ninja-build meson unzip pkg-config -y
# x86
RUN apt install libc6-i386 -y
# ARM
RUN apt install libc6-armel-cross binutils-arm-linux-gnueabi -y
RUN mkdir /etc/qemu-binfmt && \
    ln -s /usr/arm-linux-gnueabi /etc/qemu-binfmt/arm
# MIPS
RUN apt install libc6-mipsel-cross -y
RUN ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel

WORKDIR /tmp

RUN useradd -ms /bin/bash p31d4

RUN mkdir radare2 && cd radare2 && git init && \
    git remote add origin https://github.com/radareorg/radare2.git && \
    git fetch --depth 1 origin a6212ac36cfc719aef4f0dbd63834e651269fd59 && \
    git checkout FETCH_HEAD && \
    ./sys/install.sh

# Radare plugins
RUN r2pm -U
# Pseuc-C decompiler - pdd
RUN git clone https://github.com/wargio/r2dec-js.git && \
    cd r2dec-js && meson setup build && ninja -C build install
# Ghidra decompiler - pdg
#RUN r2pm -ci r2ghidra-sleigh
#RUN r2pm -i r2ghidra
#RUN git clone https://github.com/radareorg/r2ghidra.git && \
#    cd r2ghidra && ./preconfigure && ./configure --prefix=$(r2 -H R2_PREFIX) && \
#    make && make install

RUN cd /tmp && \
    git clone --depth 1 --branch 2025.04.18 https://github.com/pwndbg/pwndbg.git && \
    cd pwndbg && bash ./setup.sh

RUN python3 -m venv /opt/venv
COPY requirements.txt .
RUN . /opt/venv/bin/activate && pip3 install -r requirements.txt
