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
away from home) and your SSH key authorised on porg. If Tailscale stops, `porg`
stops resolving entirely, the tunnel retries in a loop and every port reads as
closed. `porg-tunnel status` says so in as many words.

Write `~/.zshrc.local` before pulling dotfiles onto a fresh machine, not after.
`.zshrc` and `.aliases` are symlinks into the repo, so a pull changes the live
shell straight away, and machine-specific PATH entries live only in that
gitignored file. On the MacBook that means `~/.local/node/bin`, where node and
the `pi` agent both live, so leaving it out breaks the shell before you get as
far as Supabase.

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

Worth being blunt about: there is now **one shared database per project**, not a
local copy each. Both Macs tunnel to the same containers, so a `db reset` from
either one rebuilds the database both of them are using, and a change that feels
local is visible from the other machine. Run a given project's stack from one
machine at a time. The second machine starts nothing: it just runs the app.

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

**Pinning a CLI is optional.** Both projects replay cleanly on the current CLI,
so use the Homebrew one everywhere. The wrapper still prefers a project's
`node_modules/.bin/supabase` when one exists, which is there as a safety valve:
this tool has shipped two migration-breaking regressions, so if a release ever
breaks a project mid-flight, pin that project and keep working.

**A fresh bootstrap exposes CLI migration bugs.** Nothing to do with porg: the
containers just happen to start from an empty database, so every migration
replays for the first time in a long while. Both projects hit one, and both are
now fixed in the migration, so **every project runs on the current CLI**. Fix the
migration, do not chase CLI versions: there is no version that avoids both bugs,
and older CLIs pull older service images that no longer match the data volume.

- `syntax error at end of input` (42601): the splitter truncates a function body
  mid-statement. LinkIntel's demo-data migration wrote `IF x % CASE ... END = 0`;
  hoisting the CASE into a variable fixed it.
- `CREATE INDEX CONCURRENTLY cannot be executed within a pipeline` (25001): the
  CLI wraps each migration in a statement pipeline, which rejects CONCURRENTLY.
  Keep the non-concurrent form in the file and apply CONCURRENTLY to prod by hand.

Both are [supabase/cli#5139](https://github.com/supabase/cli/issues/5139), closed
as not planned. In both cases a later migration already superseded the broken one,
but replay dies before reaching it, so the early file is what has to change. Both
were already applied on prod, where the edits are no-ops.

If a migration fails, apply it with psql through the tunnel before believing the
SQL is wrong. psql uses the simple-query protocol and swallows both cases fine.

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
