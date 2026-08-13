# Local Supabase stacks on porg

Local development databases run as Docker containers on **porg** instead of
Docker Desktop on each Mac. No Docker on the laptop, no per-machine setup of a
project's database, and the same data whichever machine you sit at.

Only the container runtime moves. The Supabase CLI, the migrations, the seed and
all the source stay on your Mac, and an SSH tunnel republishes porg's ports on
`127.0.0.1`. Every URL keeps its usual value, so **no `.env` file changes**:
`VITE_SUPABASE_URL=http://127.0.0.1:54321` still works, it just resolves to a
container on porg.

```
  Mac                                   porg
  ─────────────────────────────         ────────────────────────────
  supabase CLI ──DOCKER_HOST=ssh://──▶  dockerd  ──▶ supabase_db, auth, rest…
  app @ 127.0.0.1:54321  ──ssh -L──▶    54321…54329
```

## Why the tunnel, rather than porg's tailnet IP in .env

Pointing `.env` at `http://100.x.x.x:54321` is the obvious simpler move, and it
does work, except for OAuth. Google only allows plain HTTP redirect URIs for
loopback addresses and rejects raw IPs that aren't loopback, so
`http://100.x.x.x:54321/auth/v1/callback` cannot be registered as a redirect
URI, and local Google sign-in stops working. `config.toml` registers
`http://127.0.0.1:54321/auth/v1/callback`; LinkedIn is similarly restrictive.

The tunnel keeps every local URL on loopback, which is what those providers
privilege, and as a side effect no `.env` on any machine needs editing.

## Setting up a machine

```sh
brew install supabase/tap/supabase          # if missing
git clone git@github.com:mplacona/dotfiles.git ~/dotfiles   # if missing
bash ~/dotfiles/porg/install.sh
```

That checks SSH and Docker on porg, installs the `porg-tunnel` launch agent
(starts at login, restarts if it drops), and adds SSH connection multiplexing so
the CLI's many small Docker API calls stay fast. `.zshrc` sources
`porg/porg.zsh`, which wraps the `supabase` command.

Requirements: Tailscale connected (porg resolves over the tailnet, so this works
away from home) and your SSH key authorised on porg.

## Daily use

Nothing changes:

```sh
cd apps/dashboard
supabase start        # containers start on porg
supabase db reset     # migrations + seed, applied over the tunnel
supabase stop
```

The wrapper adds three things: it points the CLI at porg's Docker, makes sure
the tunnel is up first, and syncs the files the containers bind-mount.

| Command | What it does |
| --- | --- |
| `porg-tunnel status\|restart\|stop\|ports` | Manage the port forwards |
| `porg-sync [--watch]` | Push edge functions + email templates to porg |
| `porg-persist` | Restart policy for the stack (`porg-persist no` to disable) |
| `porg-psql [port]` | psql into a stack (default `54322`) |
| `porg-docker …` | Any docker command against porg |
| `supabase-local …` | Escape hatch: use this Mac's own Docker |

Because both machines tunnel the same ports, **run a given project's stack from
one machine at a time**. The second machine reaches the same containers through
its own tunnel without starting anything: just run the app.

## Adding a project

Each project owns a block of 10 ports so two stacks can run at once. Add it to
`projects.conf`, then `porg-tunnel restart`:

```
linkintel    54320
mentiondrop  54330
```

`54320` is the Supabase default, so that project needs no config changes. Every
other project must declare its block in `supabase/config.toml`:

```toml
[api]
port = 54331
[db]
port = 54332
shadow_port = 54330
[db.pooler]
port = 54339
[studio]
port = 54333
[inbucket]
port = 54334
```

## Things worth knowing

**Match the project's pinned CLI.** The wrapper prefers
`node_modules/.bin/supabase` over the Homebrew one. This is not tidiness: CLI
2.102 fails to apply LinkIntel's `20250810000001_insert_demo_sample_data.sql`
(it mis-splits a dollar-quoted function body and Postgres rejects the truncated
statement), while the pinned 2.39.2 applies it fine. Same failure would happen
with local Docker, but a fresh bootstrap is what exposes it.

**Log analytics is off.** vector/logflare need the Docker socket bind-mounted
from the machine running the containers, and the CLI can't resolve a socket path
for a remote host, so vector never turns healthy and blocks startup. LinkIntel's
`config.toml` sets `[analytics] enabled = false`. Cost: Studio's local Logs pane.
Container logs are still there via `porg-docker logs …`.

**Edge functions need `porg-sync`.** The CLI bind-mounts `supabase/functions`
and `supabase/templates` by absolute path, and porg has no `/Users/...` tree, so
Docker silently mounts empty directories and the runtime reports "failed to
determine entrypoint". `porg-sync` copies them to the identical path on porg;
the `supabase` wrapper runs it automatically for `start` and `functions serve`.
While iterating on a function, run `porg-sync --watch` in another pane.

Function secrets behave exactly as before: `supabase start` does not load
`supabase/.env`, so use `supabase functions serve --env-file supabase/.env`.

**Ports are published on porg's `0.0.0.0`.** Anything on your LAN or tailnet can
reach a running dev database, which uses the well-known `postgres` password. The
forwards themselves target porg's loopback, so tightening this means setting
each project's ports to bind locally on porg, not changing the tunnel.

**A porg reboot is mostly harmless.** The CLI creates its containers with
`restart=always`, so a stack comes back by itself and the tunnel reconnects.
`functions serve` is the exception: it replaces the edge runtime with a
`restart=no` container, which `porg-persist` fixes.

**Backups.** Data lives in Docker volumes on porg, which is a dev box, not
backed up. Treat these stacks as reproducible from migrations plus seed.
