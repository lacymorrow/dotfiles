# Supabase local stacks run on porg.
#
# Only the container runtime is remote: the CLI, the migrations and the source
# all stay on this machine. An SSH tunnel (see porg-tunnel) republishes porg's
# ports on 127.0.0.1, so every URL and every .env stays exactly as it was when
# the containers ran in Docker Desktop here.
#
# Sourced from .zshrc.

export PORG_HOST="${PORG_HOST:-porg}"
export PORG_DOCKER_HOST="ssh://${PORG_HOST}"

# Projects pin their own Supabase CLI. Version differences are not cosmetic:
# newer CLIs than a project's pin can fail to apply that project's migrations,
# so prefer the pinned binary and fall back to the one on PATH.
_porg_supabase_bin() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -x "$dir/node_modules/.bin/supabase" ]]; then
      printf '%s\n' "$dir/node_modules/.bin/supabase"
      return 0
    fi
    dir="${dir:h}"
  done
  whence -p supabase
}

supabase() {
  local bin sub="${1:-}"
  bin="$(_porg_supabase_bin)"
  [[ -n "$bin" ]] || { echo "supabase: no CLI found" >&2; return 1 }

  case "$sub" in
    start|stop|status|db|migration|functions|test|gen|seed)
      # Bring the tunnel up first: the CLI reaches the database over 127.0.0.1.
      if ! launchctl list com.mplacona.porg-tunnel &>/dev/null; then
        echo "porg: tunnel not running, starting it..." >&2
        porg-tunnel start >/dev/null 2>&1
        sleep 2
      fi
      ;;
  esac

  # Edge functions and auth templates are bind-mounted by absolute path, so
  # porg needs its own copy of them before those containers boot.
  case "$sub" in
    start) porg-sync >/dev/null 2>&1 || true ;;
    functions)
      [[ "${2:-}" == "serve" ]] && { porg-sync >/dev/null 2>&1 || true }
      ;;
  esac

  DOCKER_HOST="$PORG_DOCKER_HOST" "$bin" "$@"
}

# Run the CLI against this machine's own Docker, if it ever has one again.
supabase-local() {
  local bin; bin="$(_porg_supabase_bin)"
  "$bin" "$@"
}

# Any docker command, aimed at porg: `porg-docker ps`, `porg-docker logs ...`.
# This runs docker *on* porg rather than through DOCKER_HOST, so it always uses
# porg's own client and can't trip over a stale docker CLI on this Mac. (The
# Supabase CLI is unaffected: it speaks the Docker API itself.)
porg-docker() {
  local cmd
  cmd=$(printf '%q ' docker "$@")
  ssh "$PORG_HOST" "$cmd"
}

# The CLI already starts most containers with restart=always, so stacks come
# back after a porg reboot on their own. This covers the exceptions (a container
# replaced by `functions serve` comes back with restart=no). `porg-persist no`
# turns it off for every container in the stack.
porg-persist() {
  local policy="unless-stopped" names
  [[ "${1:-}" == "no" ]] && policy="no"
  names=$(porg-docker ps --filter "name=supabase_" --format '{{.Names}}')
  [[ -n "$names" ]] || { echo "porg: no supabase containers running"; return 0 }
  porg-docker update --restart "$policy" ${(f)names} >/dev/null || return 1
  echo "porg: restart policy '$policy' applied to ${#${(f)names}} containers"
}

# psql into a project's database through the tunnel. Defaults to the 54320 block.
porg-psql() {
  local port="${1:-54322}"
  psql "postgresql://postgres:postgres@127.0.0.1:${port}/postgres"
}
