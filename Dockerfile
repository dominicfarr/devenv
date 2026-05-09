FROM ubuntu:24.04

  ARG USERNAME=dev
  ARG UID=1001
  ARG GID=1001

  ENV DEBIAN_FRONTEND=noninteractive

  RUN apt-get update && apt-get install -y \
      git \
      curl \
      wget \
      build-essential \
      zsh \
      bash \
      sudo \
      ca-certificates \
      && rm -rf /var/lib/apt/lists/*

  RUN groupadd --gid $GID $USERNAME 2>/dev/null || true \
      && useradd --uid $UID --gid $GID -m -s /bin/zsh $USERNAME \
      && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

  COPY entrypoint.sh /usr/local/bin/entrypoint.sh  
  RUN chmod +x /usr/local/bin/entrypoint.sh
  USER $USERNAME
  WORKDIR /home/$USERNAME
 
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
  CMD ["zsh"]
