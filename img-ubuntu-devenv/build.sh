#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=engine.sh
source "$script_dir/engine.sh"

exec "$engine" build --pull -t "${IMAGE:-img-ubuntu-devenv:latest}" "$@" "$script_dir"
