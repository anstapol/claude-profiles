# claude-profiles

Switch between multiple Claude Code accounts instantly.

## Install

**Option A — Standalone (curl):**

```bash
curl -fsSL https://raw.githubusercontent.com/anstapol/claude-profiles/main/claude-profiles \
  -o ~/.local/bin/claude-profiles && chmod +x ~/.local/bin/claude-profiles
```

Make sure `~/.local/bin` is in your `PATH`.

**Option B — Git clone (auto-updates with `git pull`):**

```bash
git clone https://github.com/anstapol/claude-profiles.git
cd claude-profiles
./install.sh
```

Requires macOS or Linux, and Python 3.6+.

## Usage

```bash
# Save your current logged-in account
claude-profiles save work

# Log into another account and save it
claude /logout && claude
claude-profiles save personal

# Switch between them
claude-profiles use work
claude-profiles use personal

# Re-save the active account's (refreshed) tokens into an existing profile.
# Refuses unless the active account matches the profile.
claude-profiles refresh work

# Overwrite an existing profile without the confirmation prompt
claude-profiles save work -y

# List all profiles
claude-profiles list

# Show current account
claude-profiles current

# Rename a profile
claude-profiles rename work work-main

# Remove a profile
claude-profiles rm old-account
```

Restart Claude Code after switching for changes to take effect.

## Why not just `/login`?

`/login` opens your default browser and adopts whatever account is signed into claude.ai there — so if that session doesn't match the account you intended, it silently swaps you. `claude-profiles use <name>` restores credentials directly, with no browser round-trip, so the switch is deterministic regardless of browser state.

## How it works

Claude Code stores auth in two places — OAuth tokens and account metadata in **~/.claude.json**. On macOS, tokens go in the **macOS Keychain**; on Linux, they live in **~/.claude/.credentials.json**. `claude-profiles` saves and restores both. Profiles live in `~/.claude/profiles/<name>/`.

On switch, per-account caches in `~/.claude.json` (feature flags, billing eligibility, etc.) are also cleared so Claude Code re-fetches them for the new account on next startup, instead of carrying the previous account's state across.

## Security

Profile files contain OAuth tokens stored as plaintext JSON on disk. On macOS, Claude Code normally stores these in the Keychain; on Linux, they're already plaintext in `~/.claude/.credentials.json`. Saved profile directories are set to mode `700` and files to mode `600` (owner-only access), but anyone with access to your user account can read them. If this is a concern, ensure your home directory has appropriate permissions and enable full-disk encryption.
