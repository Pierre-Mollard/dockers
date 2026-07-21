# Docker images

List of tools:

- neovim
- tmux (optional because will not run inside the docker, maybe)
- cmake
- ninja
- rust
- clangd
- gcc
- fuzzy-finder
- ripgrep
- braille-snake
- mosh
- openssl
- lazyvim

## Transfer containers

On internet connected pc:

- run image, then exit without stopping (C-\ or C-P)
- docker commit <container_id> my-offline-devbox
- docker save -o devbox.tar my-offline-devbox

On remote pc:

- docker load -i devbox.tar
- docker run -it --hostname devbox my-offline-devbox

## Run compose

docker compose -f compose/devenv-ollama.yml up -d
docker compose -f compose/devenv-ollama.yml exec devenv bash

gpu version:
docker compose \
  -f compose/devenv-ollama.yml \
  -f compose/devenv-ollama.gpu.yml \
  up -d
