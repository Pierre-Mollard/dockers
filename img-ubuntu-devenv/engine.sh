# Shared by build.sh and run.sh; sourcing keeps the remaining arguments intact.
engine="${CONTAINER_ENGINE:-}"
if [[ "${1:-}" == --engine ]]; then
    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 [--engine docker|podman] [arguments...]" >&2
        exit 2
    fi
    engine="$2"
    shift 2
fi

if [[ -z "$engine" ]]; then
    if command -v docker >/dev/null 2>&1; then
        engine=docker
    elif command -v podman >/dev/null 2>&1; then
        engine=podman
    else
        echo "Install Docker or Podman, or set CONTAINER_ENGINE." >&2
        exit 1
    fi
fi

case "$engine" in
    docker|podman) ;;
    *)
        echo "Unsupported container engine: $engine (expected docker or podman)" >&2
        exit 2
        ;;
esac

if ! command -v "$engine" >/dev/null 2>&1; then
    echo "Container engine not found: $engine" >&2
    exit 1
fi
