ARG NODE_VERSION=24
FROM node:${NODE_VERSION}-bookworm-slim AS node

FROM ubuntu:24.04

# Use a supported Node LTS rather than Ubuntu 24.04's Node 18.
COPY --from=node /usr/local/ /usr/local/

ENV DEBIAN_FRONTEND=noninteractive

# Use Bash for RUN instructions:
# -e: stop on errors
# -u: fail on unset variables
# -o pipefail: fail a pipeline if any command fails
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# 1. Install Ubuntu packages, Zsh, and Zsh plugins
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        git \
        curl \
        wget \
        unzip \
        ca-certificates \
        build-essential \
        cmake \
        ninja-build \
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
        lsd \
        git-delta \
        asciinema \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Lazygit from its latest GitHub release
RUN LAZYGIT_VERSION="$( \
        curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | grep -Po '"tag_name": "v\K[^"]*' \
    )" && \
    curl -fsSLo /tmp/lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit && \
    install -m 0755 /tmp/lazygit /usr/local/bin/lazygit && \
    rm -f /tmp/lazygit /tmp/lazygit.tar.gz

# 3. Install globally managed Node tooling
RUN npm install -g \
        --engine-strict \
        prettier \
        markdownlint-cli2 \
        markdown-toc && \
    npm cache clean --force

# 4. Install Neovim from its latest release
RUN curl -fsSL \
        https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
        -o /tmp/nvim.tar.gz && \
    tar -xzf /tmp/nvim.tar.gz -C /opt && \
    ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm -f /tmp/nvim.tar.gz

# 5. Install Starship
RUN curl -fsS https://starship.rs/install.sh | sh -s -- -y

# 6. Create the non-root development user and make Zsh its login shell
RUN useradd \
        --create-home \
        --shell /usr/bin/zsh \
        dev

COPY --chown=dev:dev bashrc.sh /tmp/bashrc.sh

ENV CARGO_HOME=/home/dev/.cargo
ENV RUSTUP_HOME=/home/dev/.rustup
ENV PATH=/home/dev/.cargo/bin:${PATH}

USER dev
WORKDIR /home/dev

# 7. Install Rust, rust-analyzer, Rust sources, and Cargo-installed tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    rustup component add \
        rust-analyzer \
        rust-src \
        rustfmt \
        clippy && \
    curl -L --proto '=https' --tlsv1.2 -sSf \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
        | bash && \
    cargo binstall -y --no-track \
        xcp \
        difftastic \
        felix \
        skim \
        ast-grep \
        tree-sitter-cli \
        stylua \
        procs

# 8. Configure Bash and Zsh.
# Configured through dotfiles
RUN { \
        echo 'source "$HOME/.cargo/env"'; \
        cat /tmp/bashrc.sh; \
    } >> "$HOME/.bashrc" && \
    rm -f /tmp/bashrc.sh

# 9. Clone and stow dotfiles
RUN git clone https://github.com/Pierre-Mollard/dotfiles \
        /home/dev/PERSO/dotfiles && \
    stow \
        --dir="/home/dev/PERSO/dotfiles/stow" \
        --target="/home/dev" \
        tmux \
        vim \
        nvim \
        starship \
        zsh && \
    mkdir -p \
        /home/dev/.local/share/nvim \
        /home/dev/.local/state/nvim \
        /home/dev/.cache/nvim
