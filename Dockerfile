FROM ubuntu:latest
LABEL maintainer.name="leleact"
LABEL maintainer.eamil="leleact@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && \
  apt install -y build-essential cmake gdb gdbserver rsync vim git openssh-server zsh

RUN mkdir -p /run/sshd &&  mkdir ~/.ssh && echo \
"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAYEAt3a7UpH5XNtd0ZKOtDOsaEzEVfc7mye0Dz32Q47FVHf9GPZWVmyYcf6PeQckPLCwh8viyvaouOoe19Md0TldLBfQmrFWUUsWmNTNGvoHTYQnSC7n5Km6AJD0voTlWnGOdSh+fqvJGgl3ZgCOmpCW0WhQbLJqBisi+FkTmJZto9FHGvNd80BmI+dPa6UNEdXNWrdquaQkb7SufUSh3Jhiq+O4GzL9+qNOhv37TJxxRBZ6g93lq6rw9CJ37hTGXybgtC6ItyZvkOmkkokKL9pBE4Z/NR3AJV3kqjVc/uIp3xArF6Qht8Sx1AVV0C1myMCWekjq2V72j4Mg9JtJHKvQrnoHSYhQMELfGfQrd8YHGPmsB8mxC+FWuRrRzWhuUQtnNGQ1bjtg4st+AByEjYgN2TpYO1GZQrW7ZEiIMHHUjf/DelZpKBm2uYaFWv5GS0Tr6t88Rx2Ho6+8sTWUiQEeTDpgNT2r0Ma6oWB7rKPGxyXm9uZMMMwVKjeVpNnGz31J" >> ~/.ssh/authorized_keys

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh
RUN echo $SHELL

# 参考
# https://segmentfault.com/a/1190000015283092
# https://juejin.im/post/5cf34558f265da1b80202d75
# 安装 autojump 插件
RUN apt install -y autojump
# 安装 zsh-syntax-highlighting 插件
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 安装 zsh-autosuggestions 插件
RUN git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN sed -ri 's/^plugins=.*/plugins=(git autojump zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]