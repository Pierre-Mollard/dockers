FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

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

RUN apt-get update && apt-get install -y nodejs npm && \
    npm install -g prettier markdownlint-cli2 markdown-toc lazygit

RUN curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    -o /tmp/nvim.tar.gz && \
    tar xzf /tmp/nvim.tar.gz -C /opt && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.tar.gz

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# 1. On utilise rustup pour avoir Rust à jour (1.89+) au lieu du paquet apt figé (1.75)
# 2. On installe binstall
# 3. On utilise GITHUB_TOKEN si dispo (optionnel) ou GITHUB_API_URL pour contourner les limites
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . $HOME/.cargo/env && \
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall -y --no-track lsd xcp git-delta procs difftastic felix skim asciinema ast-grep stylua tree-sitter-cli

RUN useradd -ms /bin/bash dev

COPY --chown=dev:dev bashrc.sh /tmp/bashrc.sh

USER dev
WORKDIR /home/dev

# Modification pour injecter le path Cargo directement dans le .bashrc de l'utilisateur dev
RUN echo 'source /root/.cargo/env' >> /home/dev/.bashrc && \
    cat /tmp/bashrc.sh >> /home/dev/.bashrc && rm /tmp/bashrc.sh

RUN git clone https://github.com/Pierre-Mollard/dotfiles /home/dev/PERSO/dotfiles && \
    stow --dir="/home/dev/PERSO/dotfiles/stow" --target="/home/dev" tmux vim nvim starship
