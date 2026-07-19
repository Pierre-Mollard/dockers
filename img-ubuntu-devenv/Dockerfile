FROM ubuntu:24.04

# Éviter les questions interactives d'apt
ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour et installation des outils de base
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        neovim \
        git \
        curl \
        ca-certificates \
        build-essential \
        ripgrep \
        tmux \
        fzf \
        python3 \
        python3-pip \
        python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non-root
RUN useradd -ms /bin/bash dev

USER dev
WORKDIR /workspace

# Installer Rust via rustup pour l'utilisateur "dev"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo 'source $HOME/.cargo/env' >> $HOME/.bashrc
