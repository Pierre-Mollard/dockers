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
        cargo \
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

# Installer Starship rapidement avec son script officiel (pré-compilé)
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Créer un utilisateur non-root
RUN useradd -ms /bin/bash dev

USER dev
WORKDIR /workspace

# 1. Utiliser le cargo installé par apt (déjà dans le PATH pour root et l'utilisateur dev)
# 2. Installer `cargo-binstall` pour télécharger les binaires pré-compilés
# 3. Utiliser binstall pour les outils terminaux restants
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall -y lsd xcp git-delta procs difftastic felix skim asciinema ast-grep stylua tree-sitter-cli

# Installer dotfiles
RUN git clone https://github.com/Pierre-Mollard/dotfiles ~/workspace/PERSO/dotfiles && \
    stow --dir="$HOME/workspace/PERSO/dotfiles/stow" --target="$HOME" tmux vim nvim starship
