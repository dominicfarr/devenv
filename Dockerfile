FROM ubuntu:24.04

ARG USERNAME=dev
ARG UID=1001
ARG GID=1001

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    zsh \
    bash \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid $GID $USERNAME 2>/dev/null || true \
    && useradd --uid $UID --gid $GID -m -s /bin/zsh $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Node via nvm
ENV NVM_DIR=/home/dev/.nvm
USER $USERNAME
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install --lts \
    && nvm use --lts

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/dev/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/dev/.zshrc


# Python
USER root
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv pipx \
    && rm -rf /var/lib/apt/lists/*

# uv and ruff
USER $USERNAME
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/dev/.zshrc
RUN . $HOME/.local/bin/env && uv tool install ruff

# Bun
USER $USERNAME
RUN curl -fsSL https://bun.sh/install | bash \
    && echo 'export BUN_INSTALL="$HOME/.bun"' >> /home/dev/.zshrc \
    && echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> /home/dev/.zshrc

# Claude Code CLI
RUN . $NVM_DIR/nvm.sh && npm install -g @anthropic-ai/claude-code


USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY claude-setup.sh /usr/local/bin/claude-setup
COPY backup-context.sh /usr/local/bin/backup-context
COPY restore-context.sh /usr/local/bin/restore-context
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/claude-setup /usr/local/bin/backup-context /usr/local/bin/restore-context
USER $USERNAME
WORKDIR /home/$USERNAME

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["zsh"]
