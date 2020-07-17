FROM ubuntu:latest
LABEL maintainer.name="leleact" maintainer.eamil="leleact@gmail.com"

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

ARG RSA_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAYEAt3a7UpH5XNtd0ZKOtDOsaEzEVfc7mye0Dz32Q47FVHf9GPZWVmyYcf6PeQckPLCwh8viyvaouOoe19Md0TldLBfQmrFWUUsWmNTNGvoHTYQnSC7n5Km6AJD0voTlWnGOdSh+fqvJGgl3ZgCOmpCW0WhQbLJqBisi+FkTmJZto9FHGvNd80BmI+dPa6UNEdXNWrdquaQkb7SufUSh3Jhiq+O4GzL9+qNOhv37TJxxRBZ6g93lq6rw9CJ37hTGXybgtC6ItyZvkOmkkokKL9pBE4Z/NR3AJV3kqjVc/uIp3xArF6Qht8Sx1AVV0C1myMCWekjq2V72j4Mg9JtJHKvQrnoHSYhQMELfGfQrd8YHGPmsB8mxC+FWuRrRzWhuUQtnNGQ1bjtg4st+AByEjYgN2TpYO1GZQrW7ZEiIMHHUjf/DelZpKBm2uYaFWv5GS0Tr6t88Rx2Ho6+8sTWUiQEeTDpgNT2r0Ma6oWB7rKPGxyXm9uZMMMwVKjeVpNnGz31J"

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /run/sshd && mkdir ~/.ssh && echo $RSA_KEY >> ~/.ssh/authorized_keys && chmod 700 -R ~/.ssh

RUN apt update && apt upgrade -y && apt install -y openssh-server zsh git vim curl wget \
  build-essential cmake gdb gdbserver rsync autojump pkg-config libssh-dev libnspr4-dev \
  libnss3-dev iputils-ping inetutils-telnet iproute2 doxygen graphviz pstack clang clangd clang-format lldb \
  golang nodejs traceroute netcat dnsutils libboost-dev libsqlclient-dev

RUN groupadd -g 1000 lele && useradd -u 1000 -c "lele" -g lele -s /bin/bash -m -r lele
RUN echo "lele:lele"|chpasswd

USER lele
RUN mkdir -p /home/lele/.ssh && echo $RSA_KEY >> /home/lele/.ssh/authorized_keys && chmod 700 -R /home/lele/.ssh

RUN echo "set -o vi" >> ~/.bashrc

USER root
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/home/lele/workspace"]
