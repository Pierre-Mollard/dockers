#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=engine.sh
source "$script_dir/engine.sh"

terminal=()
if [[ -t 0 && -t 1 ]]; then
    terminal=(-it)
fi
if [[ $# -eq 0 ]]; then
    set -- bash
fi

exec "$engine" run --rm "${terminal[@]}" \
    --name ubuntu-devenv --hostname devenv \
    --volume ubuntu-devenv-nvim-data:/home/dev/.local/share/nvim \
    --volume ubuntu-devenv-nvim-state:/home/dev/.local/state/nvim \
    --volume ubuntu-devenv-nvim-cache:/home/dev/.cache/nvim \
    "${IMAGE:-img-ubuntu-devenv:latest}" "$@"
