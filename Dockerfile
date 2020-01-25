FROM docker:19.03.5-dind
# https://hub.docker.com/layers/docker/library/docker/latest/images/sha256-48db0e29e2214d564b66daffc707ad290c8788dc655cea59c605f021790d38a0

RUN apk add --no-cache py-pip python-dev libffi-dev openssl-dev gcc libc-dev make && \
    pip install docker-compose

RUN apk add bash curl

#ENV PS1="\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;33m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\]\$ "

# additional
RUN apk update && apk add git zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN which zsh
RUN sed -i "s/plugins=(git)/plugins=(git docker docker-compose kubectl)/g" ~/.zshrc
RUN cat ~/.zshrc
# common
RUN echo "alias d='docker'" >> ~/.zshenv
RUN echo "alias dc='docker-compose'" >> ~/.zshenv
RUN echo 'drm() { docker rm $(docker ps -a -q); }' >> ~/.zshenv
RUN echo "alias perm='stat -c "%a %n" *'" >> ~/.zshenv

# run docker
RUN echo "dockerd &" >> ~/.zshenv

WORKDIR /infected
ENTRYPOINT ["/bin/zsh"]
