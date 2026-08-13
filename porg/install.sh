#!/usr/bin/env bash
#
# Sets this machine up to run its local Supabase stacks on porg.
# Safe to re-run. Run it once per development machine.

set -euo pipefail

DOTFILES="$HOME/dotfiles"
PORG_DIR="$DOTFILES/porg"
LABEL="com.mplacona.porg-tunnel"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
BIN_DIR="$HOME/.local/bin"

echo "==> Checking prerequisites"
command -v supabase >/dev/null || { echo "Install the Supabase CLI first: brew install supabase/tap/supabase"; exit 1; }
ssh -o BatchMode=yes -o ConnectTimeout=10 "${PORG_HOST:-porg}" 'docker info >/dev/null' \
  || { echo "Cannot reach Docker on porg over SSH. Check Tailscale and that your key is authorised."; exit 1; }
echo "    ssh + docker on porg: ok"

echo "==> Linking porg-tunnel into $BIN_DIR"
mkdir -p "$BIN_DIR"
chmod +x "$PORG_DIR/porg-tunnel"
ln -sfn "$PORG_DIR/porg-tunnel" "$BIN_DIR/porg-tunnel"

echo "==> Adding ssh connection multiplexing for porg"
mkdir -p "$HOME/.ssh/sockets"
if ! grep -qE '^Host porg$' "$HOME/.ssh/config" 2>/dev/null; then
  cat >> "$HOME/.ssh/config" <<'EOF'

Host porg
  # Reuse one connection for the many short Docker API calls the Supabase CLI
  # makes, instead of a fresh SSH handshake per call.
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%r@%h-%p
  ControlPersist 10m
  ServerAliveInterval 30
EOF
  echo "    added Host porg block"
else
  echo "    Host porg block already present, leaving it alone"
fi

echo "==> Installing the tunnel launch agent"
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>${PORG_DIR}/porg-tunnel</string>
    <string>foreground</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>ThrottleInterval</key>
  <integer>10</integer>
  <key>EnvironmentVariables</key>
  <dict>
    <key>HOME</key>
    <string>${HOME}</string>
    <key>PATH</key>
    <string>/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin</string>
  </dict>
  <key>StandardOutPath</key>
  <string>${HOME}/Library/Logs/porg-tunnel.log</string>
  <key>StandardErrorPath</key>
  <string>${HOME}/Library/Logs/porg-tunnel.log</string>
</dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)/${LABEL}" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"
sleep 2

echo "==> Status"
"$PORG_DIR/porg-tunnel" status
echo
echo "Done. Make sure .zshrc sources porg/porg.zsh, then open a new shell and run:"
echo "  cd <project> && supabase start"
