FROM ubuntu:24.04

# Éviter les questions interactives d'apt
ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour et installation des outils de base
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        git \
        curl \
        wget \
        unzip \
        ca-certificates \
        build-essential \
        clangd \
        clang \
        libclang-dev \
        ripgrep \
        tmux \
        fzf \
        python3 \
        python3-pip \
        python3-venv \
        stow \
        fd-find \
        shellcheck \
        shfmt \
        xz-utils \
        bat \
        bear \
        ccache \
        vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Npm
RUN apt-get update && apt-get install -y nodejs npm && \
    npm install -g prettier markdownlint-cli2 markdown-toc lazygit

# Installer Neovim depuis la release officielle
RUN curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    -o /tmp/nvim.tar.gz && \
    tar xzf /tmp/nvim.tar.gz -C /opt && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.tar.gz

# Créer un utilisateur non-root
RUN useradd -ms /bin/bash dev

USER dev
WORKDIR /workspace

# Installer Rust via rustup pour l'utilisateur "dev"
# Instaler les packages cargo pour l'utilisateur "dev"
 RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo 'source $HOME/.cargo/env' >> $HOME/.bashrc && \
    . "$HOME/.cargo/env" && \
    rustup component add rust-analyzer && \
    cargo install tree-sitter-cli --locked && \
    cargo install lsd && \
    cargo install xcp && \
    cargo install git-delta && \
    cargo install procs && \
    cargo install difftastic && \
    cargo install felix && \
    cargo install skim && \
    cargo install asciinema && \
    cargo install starship && \
    cargo install ast-grep && \
    cargo install stylua

# Installer dotfiles pour l'utilisateur "dev"
RUN git clone https://github.com/Pierre-Mollard/dotfiles ~/workspace/PERSO/dotfiles
RUN stow --dir="$HOME/workspace/PERSO/dotfiles/stow" --target="$HOME" tmux vim nvim starship
