FROM ubuntu:latest
LABEL maintainer.name="leleact" maintainer.eamil="leleact@gmail.com"

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

ARG RSA_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEA2EaNcbxunPssHgomDSW3JcOhSnAYKN9+760WOpgDpHG4gnIjDqw7g9zaZwzy6JGUdUpI7TecBdXcCTXLBq3E9GM/Y7hhlUJlRL6axgDbP256Olalj5X755RTVWpxwyUve9t4KylOPrzIacdcwB9q6cxICmhTMfDn3zRfrhdn1ZoONfA/CGWUj4l2xBSPaZZrrkw0AVOUY9DxoPDmzjCiybBvLvgOjTPD7l0+fcFkvsAYC3mf06KqzGGPmLpmQhqXvRHc8oXLztx1RgFk6tJWMRCAoWVevUWvxl2fKM1cafuQ9uk4ErFLB3uSa1CixtA6QYhDdFzRM40l0HZWB9v3eDV1Cih1NJ5pyfT3lP4nisZRoGtWwpXSKXV8GfrtCcsxBdVv81nsVd84N54Pmjh7YDUFTzFbhCAHpGdAZINDzjNhSoF5RN0x6PYPYa7TP+4VnViccjMsPBjnbXjbbjKFj4XFFsTT86BZdf/rAdi0c/GfGB+UcGj+CJbdp32TKdQtBTcJ7icYqe5+pBd8CUbVIHhiyYsLTPqJ6JyoV5TfEAxc1dlsqTOtdXsldKr8GnN58Dv45rfRLAJ6QTe3WFSJV34GYG7MXHHD/cZ6yMCvRyN0yCAVQPoqYtWXpaSzbg1mEljuM8Jm3Y56mbt1JqdaEfOv1IP9MzH+iQq8ShyJGEU="

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /run/sshd && mkdir ~/.ssh && echo $RSA_KEY >> ~/.ssh/authorized_keys && chmod 700 -R ~/.ssh && chmod 600 ~/.ssh/authorized_keys

RUN apt update && apt upgrade -y && apt install -y openssh-server zsh git vim curl wget \
  build-essential cmake gdb gdbserver rsync autojump pkg-config libssh-dev libnspr4-dev \
  libnss3-dev iputils-ping inetutils-telnet iproute2 doxygen graphviz pstack clang clangd clang-format lldb \
  golang nodejs traceroute netcat dnsutils libboost-dev libsqlclient-dev gdb

RUN groupadd -g 1000 lele && useradd -u 1000 -c "lele" -g lele -s /bin/bash -m -r lele
RUN echo "lele:lele"|chpasswd

USER lele
RUN mkdir -p /home/lele/.ssh && echo $RSA_KEY >> /home/lele/.ssh/authorized_keys && chmod 700 -R /home/lele/.ssh && chmod 600 ~/.ssh/authorized_keys

RUN echo "set -o vi" >> ~/.bashrc

USER root
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/home/lele/workspace"]
