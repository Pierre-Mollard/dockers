FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install core dependencies and natively available Ubuntu tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        git curl wget unzip ca-certificates build-essential \
        clangd clang libclang-dev \
        ripgrep tmux fzf python3 python3-pip python3-venv stow fd-find \
        shellcheck shfmt xz-utils bat bear ccache vim \
        lsd git-delta asciinema \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install Lazygit via direct GitHub binary download
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin && \
    rm lazygit.tar.gz lazygit

# 3. Install Node.js and NPM packages (including tree-sitter-cli natively)
RUN apt-get update && apt-get install -y nodejs npm && \
    npm install -g prettier markdownlint-cli2 markdown-toc tree-sitter-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Install Neovim via GitHub release
RUN curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    -o /tmp/nvim.tar.gz && \
    tar xzf /tmp/nvim.tar.gz -C /opt && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.tar.gz

# 5. Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# 6. Create dev user and set up permissions
RUN useradd -ms /bin/bash dev
COPY --chown=dev:dev bashrc.sh /tmp/bashrc.sh

USER dev
WORKDIR /home/dev

# 7. Install Rust and fetch pre-compiled binaries via cargo-binstall
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . $HOME/.cargo/env && \
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall -y --no-track xcp difftastic felix skim ast-grep stylua procs

# 8. Configure bashrc and dotfiles
RUN echo 'source $HOME/.cargo/env' >> /home/dev/.bashrc && \
    cat /tmp/bashrc.sh >> /home/dev/.bashrc && rm /tmp/bashrc.sh

# 9. Clone and setup dotfiles
RUN git clone https://github.com/Pierre-Mollard/dotfiles /home/dev/PERSO/dotfiles && \
    stow --dir="/home/dev/PERSO/dotfiles/stow" --target="/home/dev" tmux vim nvim starship
