# Ubuntu Neovim development image

The Dockerfile works with both Docker and Podman. The scripts prefer Docker
when both are installed; override with `--engine` or `CONTAINER_ENGINE`.
Images and volumes are separate for each engine.

```sh
# These scripts work from any directory.
./img-ubuntu-devenv/build.sh --engine docker
./img-ubuntu-devenv/run.sh --engine docker

./img-ubuntu-devenv/build.sh --engine podman
./img-ubuntu-devenv/run.sh --engine podman

# Build options are forwarded to the engine; commands follow the run options.
./img-ubuntu-devenv/build.sh --engine docker --no-cache
./img-ubuntu-devenv/run.sh --engine docker nvim
CONTAINER_ENGINE=podman ./img-ubuntu-devenv/run.sh zsh
```

`IMAGE` overrides the default `img-ubuntu-devenv:latest` tag. Builds pull current
base images. Use `--no-cache` to refresh downloaded tools and the dotfiles clone:
Docker/Podman cannot detect upstream changes in cached `RUN` instructions.

The image includes Node 24 LTS, CMake, Ninja, clangd, Rust/rust-analyzer,
and the Tree-sitter CLI (installed through Cargo, not npm).
Node's major version can be overridden with `--build-arg NODE_VERSION=24`.
Neovim and Lazygit downloads currently target **x86_64 Linux**.

## Persistence and first launch

`run.sh` keeps Neovim plugins, Mason tools, parsers, state, and cache in three
named volumes. The rest of the container is disposable. First launch requires
internet; allow installations to finish, then restart Neovim. After rebuilding,
use `:Lazy sync`, `:Mason`, and `:TSUpdate` as needed to update persisted tools.

Projects are not mounted automatically. To edit a host project, run the engine
directly with a bind mount, for example:

```sh
docker run --rm -it \
  --mount "type=bind,source=$PWD,target=/workspace" \
  --workdir /workspace \
  --volume ubuntu-devenv-nvim-data:/home/dev/.local/share/nvim \
  --volume ubuntu-devenv-nvim-state:/home/dev/.local/state/nvim \
  --volume ubuntu-devenv-nvim-cache:/home/dev/.cache/nvim \
  img-ubuntu-devenv:latest bash
```

Bind-mount write permissions must match the container's `dev` user. With
rootless Podman, configure `--userns=keep-id:uid=1001,gid=1001` for this image's
default user IDs; on SELinux hosts, a private project mount may also need `:Z`.
Do not relabel your entire home directory.

The Compose setup instead persists **all of `/home/dev`** in `home_dev`.
An existing home volume hides rebuilt home-directory content, including Rust
and dotfiles. Back up your work and update that volume's tools/configuration
explicitly; rebuilding alone does not refresh them.
