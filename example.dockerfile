FROM <docekr image path>

RUN sudo apt update -y

RUN sudo apt install -y clangd-12
RUN sudo ln -s /usr/bin/clangd-12 /usr/bin/clangd
RUN sudo apt install -y gdb
RUN sudo apt install -y zsh

RUN sudo apt install -y locales
RUN sudo locale-gen zh_CN
RUN sudo locale-gen zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8


RUN pip3 install mako>=1.0.7
RUN pip3 install clang>=14.0
RUN pip3 install protobuf>=4.21.0
RUN pip3 install autopep8

# make 'colcon build' happy
RUN pip install --upgrade --force-reinstall numpy

RUN useradd -m -s /bin/bash swq && \
    echo 'swq:swq' | chpasswd

# Add 'swq' to the sudo group
RUN usermod -aG sudo swq

# Switch to the 'swq' user
USER swq

### setup git branch view in cli ############
RUN echo "parse_git_branch() {" >> /home/swq/.bashrc \
    && echo "    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\\\1)/'" >> /home/swq/.bashrc \
    && echo "}" >> /home/swq/.bashrc \
    && echo "export PS1='\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ '" >> /home/swq/.bashrc


# install ohmyzsh
RUN sh -c "$(wget -O- https://github.com/shan-weiqiang/zsh-in-docker/releases/download/v0.0.5/zsh-in-docker.1.sh)" -- \
    -x \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -t robbyrussell


CMD /bin/bash
