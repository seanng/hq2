#!/usr/bin/env bash
# setup.sh — bootstrap a fresh hq2 clone on macOS
#
# This script installs everything the vendored skills in .agents/skills/ depend on
# (CLIs, Python packages, Node packages, system tools), bootstraps auth/keys for
# the third-party services those skills use, and finishes vault setup (IDENTITY
# safety net, Claude Code plugin, personal branch).
#
# It works wherever you cloned this repo: the vault root is derived from the
# script's own location (or $CLAUDE_PROJECT_DIR if set). Nothing is hardcoded to
# a particular path.
#
# Idempotent: re-running is safe. Each step checks whether work is already done
# and skips if so.
#
# Flags:
#   --dry-run    Print what would be installed/changed without doing it. Also
#                routes shell-rc modifications to a temp file instead of the
#                real ~/.zshrc / ~/.bashrc. Use this while iterating.
#   --skip-vault Skip the post-prereqs vault steps (IDENTITY safety net, structure
#                scaffolding, plugin, branch). Useful if you only want to
#                (re)install dependencies.
#   --help       Show this help.

set -u
set -o pipefail

# ---------------------------------------------------------------------------
# Globals
# ---------------------------------------------------------------------------

DRY_RUN=0
SKIP_VAULT=0

# Vault root = the directory this script lives in. Prefer $CLAUDE_PROJECT_DIR
# when it is set and actually points at this checkout (Claude Code exports it),
# otherwise fall back to the script's own location. Never hardcode a path: the
# friend may clone this anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "${CLAUDE_PROJECT_DIR}/.claude" ]; then
  VAULT_ROOT="$CLAUDE_PROJECT_DIR"
else
  VAULT_ROOT="$SCRIPT_DIR"
fi

# Track failures for the verification grid at the end.
declare -a VERIFY_NAMES=()
declare -a VERIFY_STATUSES=()  # ok | fail
declare -a VERIFY_DETAILS=()

# ---------------------------------------------------------------------------
# Colors (skip if not a TTY)
# ---------------------------------------------------------------------------

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
  C_CYAN=$'\033[36m'
else
  C_RESET=""; C_BOLD=""; C_DIM=""; C_RED=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_CYAN=""
fi

# ---------------------------------------------------------------------------
# Logging helpers
# ---------------------------------------------------------------------------

log()    { printf "%s\n" "$*"; }
info()   { printf "${C_CYAN}==>${C_RESET} %s\n" "$*"; }
ok()     { printf "  ${C_GREEN}OK${C_RESET}    %s\n" "$*"; }
skip()   { printf "  ${C_DIM}skip${C_RESET}  %s\n" "$*"; }
warn()   { printf "  ${C_YELLOW}warn${C_RESET}  %s\n" "$*"; }
fail()   { printf "  ${C_RED}fail${C_RESET}  %s\n" "$*"; }
header() { printf "\n${C_BOLD}%s${C_RESET}\n" "$*"; }

dry_note() {
  if [ "$DRY_RUN" = "1" ]; then
    printf "  ${C_YELLOW}DRY${C_RESET}   would run: %s\n" "$*"
  fi
}

# Run a command, or print it if dry-run.
run() {
  if [ "$DRY_RUN" = "1" ]; then
    dry_note "$*"
    return 0
  fi
  "$@"
}

# Record a verification result.
record() {
  VERIFY_NAMES+=("$1")
  VERIFY_STATUSES+=("$2")
  VERIFY_DETAILS+=("${3:-}")
}

# ---------------------------------------------------------------------------
# Arg parsing
# ---------------------------------------------------------------------------

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)    DRY_RUN=1 ;;
    --skip-vault) SKIP_VAULT=1 ;;
    --help|-h)
      sed -n '2,21p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) printf "${C_RED}Unknown flag:${C_RESET} %s\n\n" "$1"; exit 2 ;;
  esac
  shift
done

if [ "$DRY_RUN" = "1" ]; then
  printf "${C_YELLOW}${C_BOLD}*** DRY RUN ***${C_RESET}  No changes will be made.\n"
fi

info "Vault root: $VAULT_ROOT"

# ---------------------------------------------------------------------------
# Step 1: prereq checks (we do NOT auto-install these)
# ---------------------------------------------------------------------------

header "1. Checking system prerequisites"

REQUIRED_BINS=(
  "brew:Homebrew (https://brew.sh)"
  "python3:Python 3 (brew install python)"
  "pip3:pip3 (ships with Python 3 from Homebrew)"
  "node:Node.js (brew install node)"
  "npm:npm (ships with Node)"
  "git:git (brew install git)"
  "claude:Claude Code CLI (https://docs.anthropic.com/en/docs/claude-code)"
)

MISSING_PREREQS=0
for entry in "${REQUIRED_BINS[@]}"; do
  bin="${entry%%:*}"
  desc="${entry#*:}"
  if command -v "$bin" >/dev/null 2>&1; then
    ok "$bin found ($(command -v "$bin"))"
  else
    fail "$bin not found — install: $desc"
    MISSING_PREREQS=1
  fi
done

if [ "$MISSING_PREREQS" = "1" ]; then
  printf "\n${C_RED}Missing system prerequisites.${C_RESET} Install the tools above and re-run setup.sh.\n"
  exit 1
fi

# Detect macOS — we only support macOS.
case "$(uname -s)" in
  Darwin) ;;
  *) warn "This script is designed for macOS. Other systems are unsupported." ;;
esac

# ---------------------------------------------------------------------------
# Step 2: detect target shell rc (zsh by default on modern macOS)
# ---------------------------------------------------------------------------

detect_shell_rc() {
  local shell_name="${SHELL##*/}"
  case "$shell_name" in
    zsh)  printf "%s/.zshrc" "$HOME" ;;
    bash) if [ -f "$HOME/.bash_profile" ]; then
            printf "%s/.bash_profile" "$HOME"
          else
            printf "%s/.bashrc" "$HOME"
          fi ;;
    *)    printf "%s/.zshrc" "$HOME" ;;  # safe default on macOS
  esac
}

SHELL_RC="$(detect_shell_rc)"
# In dry-run we redirect rc writes to a scratch file so we never touch the user's real rc.
if [ "$DRY_RUN" = "1" ]; then
  SHELL_RC_REAL="$SHELL_RC"
  SHELL_RC="$(mktemp -t hq-setup-shellrc.XXXXXX)"
  # Seed the temp rc with the real one so idempotency checks reflect reality.
  if [ -f "$SHELL_RC_REAL" ]; then
    cp "$SHELL_RC_REAL" "$SHELL_RC"
  fi
  info "Dry-run: shell rc writes will go to $SHELL_RC (not $SHELL_RC_REAL)"
fi

# ---------------------------------------------------------------------------
# Step 3: Python packages (for pptx + pdf skills used by Pippa)
# ---------------------------------------------------------------------------

header "2. Installing Python packages (pptx + pdf skills)"

# Determined by inspecting .agents/skills/pptx/scripts/ and .agents/skills/pdf/scripts/.
# - python-pptx: implicit, used by pptx authoring
# - Pillow: thumbnail.py uses PIL
# - defusedxml + lxml: office/unpack.py, office/pack.py
# - pdf2image, pypdf, pdfplumber: pdf/scripts/*
# - markitdown[pptx]: pptx SKILL.md "Read/analyze content" path
PY_PACKAGES=(
  "python-pptx"
  "Pillow"
  "defusedxml"
  "lxml"
  "pdf2image"
  "pypdf"
  "pdfplumber"
  "markitdown[pptx]"
)

# pip3 install --user works on most macOS Python installs. We use --break-system-packages
# only if pip refuses; otherwise we let it use the user site.
PIP_FLAGS=(--user)

py_is_installed() {
  # Strip extras like [pptx] for the import check.
  local pkg="${1%%\[*}"
  python3 -c "import importlib.metadata, sys; sys.exit(0 if importlib.metadata.distribution('$pkg') else 1)" >/dev/null 2>&1
}

for pkg in "${PY_PACKAGES[@]}"; do
  if py_is_installed "$pkg"; then
    skip "$pkg already installed"
    record "py:$pkg" ok ""
  else
    info "Installing $pkg via pip3"
    if run pip3 install "${PIP_FLAGS[@]}" "$pkg"; then
      ok "$pkg installed"
      record "py:$pkg" ok ""
    else
      # Some Homebrew Pythons mark themselves as externally managed (PEP 668).
      # Retry with --break-system-packages, which is the supported user override.
      warn "$pkg pip3 install failed; retrying with --break-system-packages"
      if run pip3 install --user --break-system-packages "$pkg"; then
        ok "$pkg installed (with --break-system-packages)"
        record "py:$pkg" ok "installed with --break-system-packages"
      else
        fail "$pkg install failed"
        record "py:$pkg" fail "pip3 install failed; install manually"
      fi
    fi
  fi
done

# ---------------------------------------------------------------------------
# Step 4: Node global packages
# ---------------------------------------------------------------------------

header "3. Installing Node global packages"

# Discovered via inspecting installed binaries:
#   gws  -> @googleworkspace/cli (npm)
#   agent-browser -> agent-browser (npm)
#   pptxgenjs -> pptxgenjs (npm, optional, used by pptx JS path)
NODE_PACKAGES=(
  "@googleworkspace/cli:gws"
  "agent-browser:agent-browser"
  "pptxgenjs:"   # pptxgenjs is a library, no CLI binary; we check via npm ls
)

npm_is_installed_global() {
  local pkg="$1"
  npm ls -g --depth=0 "$pkg" >/dev/null 2>&1
}

for entry in "${NODE_PACKAGES[@]}"; do
  pkg="${entry%%:*}"
  bin="${entry#*:}"
  if [ -n "$bin" ] && command -v "$bin" >/dev/null 2>&1; then
    skip "$pkg already installed ($bin found at $(command -v "$bin"))"
    record "npm:$pkg" ok ""
  elif npm_is_installed_global "$pkg"; then
    skip "$pkg already installed (npm global)"
    record "npm:$pkg" ok ""
  else
    info "Installing $pkg via npm -g"
    if run npm install -g "$pkg"; then
      ok "$pkg installed"
      record "npm:$pkg" ok ""
    else
      fail "$pkg install failed"
      record "npm:$pkg" fail "npm install -g $pkg failed"
    fi
  fi
done

# ---------------------------------------------------------------------------
# Step 5: tavily-cli (uses its own installer — leverages uv under the hood)
# ---------------------------------------------------------------------------

header "4. Installing tavily-cli"

if command -v tvly >/dev/null 2>&1; then
  skip "tvly already installed ($(command -v tvly))"
  record "tvly" ok ""
else
  info "Installing tavily-cli (via official installer; uses uv)"
  if run bash -c 'curl -fsSL https://cli.tavily.com/install.sh | bash'; then
    # The installer puts tvly at ~/.local/bin which may not yet be on PATH for this shell.
    if [ -x "$HOME/.local/bin/tvly" ] || command -v tvly >/dev/null 2>&1; then
      ok "tvly installed"
      record "tvly" ok ""
      # Make sure ~/.local/bin is on PATH for future shells.
      if ! grep -q "HQ setup: PATH ~/.local/bin" "$SHELL_RC" 2>/dev/null; then
        if ! printf '%s\n' "$PATH" | tr ':' '\n' | grep -qx "$HOME/.local/bin"; then
          info "Adding ~/.local/bin to PATH in $SHELL_RC"
          if [ "$DRY_RUN" = "1" ]; then
            dry_note "append PATH block to $SHELL_RC"
          else
            {
              printf '\n# --- HQ setup: PATH ~/.local/bin (tvly + uv tools) ---\n'
              printf 'export PATH="$HOME/.local/bin:$PATH"\n'
              printf '# --- end HQ setup ---\n'
            } >> "$SHELL_RC"
          fi
        fi
      fi
    else
      fail "tvly installer ran but tvly is not on PATH"
      record "tvly" fail "installer succeeded but binary not found"
    fi
  else
    fail "tavily-cli installer failed"
    record "tvly" fail "curl | bash installer failed; try: pip3 install --user tavily-cli"
  fi
fi

# ---------------------------------------------------------------------------
# Step 6: agent-browser Chrome download
# ---------------------------------------------------------------------------

header "5. Setting up agent-browser (Chrome)"

if command -v agent-browser >/dev/null 2>&1; then
  # agent-browser install is idempotent; it checks for an existing install before downloading.
  info "Running 'agent-browser install' to fetch Chrome (idempotent; skips if present)"
  if run agent-browser install; then
    ok "agent-browser Chrome ready"
    record "agent-browser:chrome" ok ""
  else
    fail "agent-browser install failed"
    record "agent-browser:chrome" fail "run 'agent-browser install' manually"
  fi
else
  fail "agent-browser binary not on PATH after npm install"
  record "agent-browser:chrome" fail "agent-browser binary missing"
fi

# ---------------------------------------------------------------------------
# Step 7: System tools via Homebrew (LibreOffice for soffice, Poppler for pdftoppm)
# ---------------------------------------------------------------------------

header "6. Installing system tools (LibreOffice, Poppler)"

# LibreOffice provides `soffice` (used by pptx skill's PDF conversion path).
if command -v soffice >/dev/null 2>&1; then
  skip "soffice already installed ($(command -v soffice))"
  record "soffice" ok ""
else
  info "Installing LibreOffice via Homebrew (large download; few minutes)"
  if run brew install --cask libreoffice; then
    ok "LibreOffice installed"
    record "soffice" ok ""
  else
    fail "LibreOffice install failed"
    record "soffice" fail "brew install --cask libreoffice failed; install manually"
  fi
fi

# Poppler provides `pdftoppm` (used by pptx skill for PDF -> image conversion).
if command -v pdftoppm >/dev/null 2>&1; then
  skip "pdftoppm already installed ($(command -v pdftoppm))"
  record "pdftoppm" ok ""
else
  info "Installing Poppler via Homebrew"
  if run brew install poppler; then
    ok "Poppler installed"
    record "pdftoppm" ok ""
  else
    fail "Poppler install failed"
    record "pdftoppm" fail "brew install poppler failed; install manually"
  fi
fi

# ---------------------------------------------------------------------------
# Step 8: Interactive bootstrap — TAVILY_API_KEY
# ---------------------------------------------------------------------------

header "7. Bootstrap: TAVILY_API_KEY"

TAVILY_MARKER_BEGIN="# --- HQ setup: TAVILY_API_KEY ---"
TAVILY_MARKER_END="# --- end HQ setup: TAVILY_API_KEY ---"

tavily_in_rc() {
  [ -f "$SHELL_RC" ] && grep -qF "$TAVILY_MARKER_BEGIN" "$SHELL_RC"
}

if [ -n "${TAVILY_API_KEY:-}" ]; then
  skip "TAVILY_API_KEY already set in current environment"
  record "TAVILY_API_KEY" ok "from current environment"
elif tavily_in_rc; then
  skip "TAVILY_API_KEY already configured in $SHELL_RC (HQ setup block found)"
  record "TAVILY_API_KEY" ok "found in $SHELL_RC"
else
  log "Tavily powers the Isaac researcher agent. You need an API key from https://tavily.com (free tier available)."
  log "Paste your Tavily key here. Leave blank to skip and configure later."
  if [ "$DRY_RUN" = "1" ]; then
    dry_note "prompt user for TAVILY_API_KEY and append marker block to $SHELL_RC"
    record "TAVILY_API_KEY" ok "skipped in dry-run"
  else
    printf "  TAVILY_API_KEY: "
    read -r TAVILY_INPUT
    if [ -z "$TAVILY_INPUT" ]; then
      warn "Skipped Tavily key setup. Re-run setup.sh or set TAVILY_API_KEY manually in $SHELL_RC."
      record "TAVILY_API_KEY" fail "not configured; tavily-cli won't work until you set it"
    else
      {
        printf '\n%s\n' "$TAVILY_MARKER_BEGIN"
        printf 'export TAVILY_API_KEY=%q\n' "$TAVILY_INPUT"
        printf '%s\n' "$TAVILY_MARKER_END"
      } >> "$SHELL_RC"
      ok "TAVILY_API_KEY appended to $SHELL_RC"
      record "TAVILY_API_KEY" ok "saved to $SHELL_RC"
      export TAVILY_API_KEY="$TAVILY_INPUT"
    fi
  fi
fi

# ---------------------------------------------------------------------------
# Step 9: Interactive bootstrap — Google OAuth for gws
# ---------------------------------------------------------------------------

header "8. Bootstrap: Google Workspace OAuth (gws auth login)"

# Path to the OAuth client config bundled with the repo. This is a Desktop-app
# OAuth client from the GCP project `seangentic-gdrive-for-claude`, shared so
# friends don't need to set up their own GCP project. See hp-007 for rationale.
#
# Note: .agents/auth/ is git-ignored (credentials never enter the tracked
# framework), so a fresh clone will NOT contain this file. The operator delivers
# it to the friend out-of-band; until it's present, this step gracefully falls
# back to the manual `gws auth setup` path below.
BUNDLED_GWS_CLIENT_SECRET="$VAULT_ROOT/.agents/auth/gws-client-secret.json"
# Where gws expects to find client_secret.json. We mirror gws's default layout
# rather than calling `gws auth setup` (which requires gcloud — the dep we are
# specifically eliminating with the bundled client).
GWS_CONFIG_DIR="$HOME/.config/gws"
GWS_CLIENT_SECRET_DEST="$GWS_CONFIG_DIR/client_secret.json"

if ! command -v gws >/dev/null 2>&1; then
  fail "gws not on PATH; skipping OAuth step"
  record "gws:oauth" fail "gws binary missing"
else
  # Parse gws auth status JSON. The output is prefixed with "Using keyring backend: ..."
  # so we strip everything before the first '{'.
  GWS_STATUS_JSON="$(gws auth status 2>/dev/null | sed -n '/^{/,$p' || printf '{}')"
  CLIENT_OK=$(printf '%s' "$GWS_STATUS_JSON" | python3 -c "import json,sys;
try:
    d=json.load(sys.stdin)
    print('yes' if d.get('client_config_exists') else 'no')
except Exception:
    print('no')" 2>/dev/null || echo "no")
  TOKEN_OK=$(printf '%s' "$GWS_STATUS_JSON" | python3 -c "import json,sys;
try:
    d=json.load(sys.stdin)
    print('yes' if d.get('token_valid') else 'no')
except Exception:
    print('no')" 2>/dev/null || echo "no")

  if [ "$TOKEN_OK" = "yes" ]; then
    skip "gws already authenticated (valid token)"
    record "gws:oauth" ok "valid token in keyring"
  else
    # If the OAuth client config isn't installed yet, install it from the
    # bundled copy. This replaces the hp-005 warn-and-skip path.
    if [ "$CLIENT_OK" = "no" ]; then
      if [ -f "$BUNDLED_GWS_CLIENT_SECRET" ]; then
        info "Installing shared OAuth client from bundled file into $GWS_CLIENT_SECRET_DEST"
        if [ "$DRY_RUN" = "1" ]; then
          dry_note "mkdir -p $GWS_CONFIG_DIR && install -m 600 <bundled client_secret> $GWS_CLIENT_SECRET_DEST"
          # Pretend success for the rest of the flow in dry-run.
          CLIENT_OK="yes"
        else
          if mkdir -p "$GWS_CONFIG_DIR" \
             && install -m 600 "$BUNDLED_GWS_CLIENT_SECRET" "$GWS_CLIENT_SECRET_DEST"; then
            ok "Shared OAuth client installed (from $BUNDLED_GWS_CLIENT_SECRET)"
            CLIENT_OK="yes"
          else
            fail "Failed to install bundled OAuth client to $GWS_CLIENT_SECRET_DEST"
            log "  Remediation: manually copy $BUNDLED_GWS_CLIENT_SECRET to $GWS_CLIENT_SECRET_DEST (mode 600)."
            record "gws:oauth" fail "could not install bundled client_secret.json"
          fi
        fi
      else
        # Bundled file missing — expected on a fresh clone. Fall back to manual setup.
        warn "gws is not configured with an OAuth client (no client_secret.json)."
        warn "The bundled OAuth client was expected at $BUNDLED_GWS_CLIENT_SECRET but is missing."
        warn "This file is git-ignored, so a fresh clone won't have it — ask the operator for it,"
        warn "or run 'gws auth setup' yourself (requires gcloud + a GCP project)."
        warn "See: https://github.com/googleworkspace/cli for setup instructions."
        warn "Skipping OAuth step. Pippa and Sam will not be able to talk to Google Workspace until this is configured."
        record "gws:oauth" fail "no OAuth client configured and bundled file missing; obtain client_secret.json or run 'gws auth setup'"
      fi
    fi

    # If we now have a client (either pre-existing or freshly installed), run login.
    if [ "$CLIENT_OK" = "yes" ]; then
      log "gws is configured with an OAuth client but has no valid token. Triggering 'gws auth login' now."
      log "This will open a browser window for Google OAuth. If the browser can't open the callback URL, the flow will fail —"
      log "in that case retry, or run 'gws auth login' manually after setup completes."
      if [ "$DRY_RUN" = "1" ]; then
        dry_note "gws auth login"
        record "gws:oauth" ok "skipped in dry-run"
      else
        if run gws auth login; then
          ok "gws OAuth complete"
          record "gws:oauth" ok ""
        else
          fail "gws auth login failed. Common cause: callback port already in use (another OAuth flow running)."
          log "  Retry: close other OAuth flows and run 'gws auth login' manually."
          record "gws:oauth" fail "OAuth flow failed; retry 'gws auth login' manually"
        fi
      fi
    fi
  fi
fi

# ---------------------------------------------------------------------------
# Step 10: Vault setup (IDENTITY safety net, structure scaffolding, plugin, branch)
# ---------------------------------------------------------------------------

if [ "$SKIP_VAULT" = "1" ]; then
  header "9. Vault setup (skipped via --skip-vault)"
else
  header "9. Vault setup (IDENTITY, structure, plugin, branch)"

  # --- IDENTITY safety net ---------------------------------------------------
  # hq2 uses a per-person IDENTITY.md at the vault root (git-ignored) instead of
  # the retired 2-areas/hq/assistant/personal-context.md. We only GUARANTEE the
  # file exists by seeding it from the tracked template; we do NOT populate it.
  # Pam runs a first-run interview to fill it in (hp-010).
  IDENTITY_FILE="$VAULT_ROOT/IDENTITY.md"
  IDENTITY_TEMPLATE="$VAULT_ROOT/IDENTITY.example.md"
  if [ -f "$IDENTITY_FILE" ]; then
    skip "IDENTITY.md already exists (leaving it untouched)"
  elif [ -f "$IDENTITY_TEMPLATE" ]; then
    if run cp "$IDENTITY_TEMPLATE" "$IDENTITY_FILE"; then
      ok "Seeded IDENTITY.md from IDENTITY.example.md — Pam will help you fill it in on first run"
    else
      fail "Could not seed IDENTITY.md from $IDENTITY_TEMPLATE"
    fi
  else
    warn "IDENTITY.example.md not found at $IDENTITY_TEMPLATE; skipping IDENTITY safety net"
  fi

  # --- Structure scaffolding -------------------------------------------------
  # Ensure the hq2 content/structure shape exists. areas/ holds all per-person
  # content and is git-ignored (kept alive by .gitkeep); system/ holds shared
  # conventions and templates. These should already be present from the clone,
  # but we (re)create them defensively so the vault is usable even if a dir was
  # pruned. No PARA scaffolding (1-projects/, 2-areas/, 0-inbox/) — those are
  # retired.
  AREAS_DIR="$VAULT_ROOT/areas"
  AREAS_GITKEEP="$AREAS_DIR/.gitkeep"
  if [ -f "$AREAS_GITKEEP" ]; then
    skip "areas/.gitkeep already present"
  else
    if run mkdir -p "$AREAS_DIR" && run touch "$AREAS_GITKEEP"; then
      ok "Scaffolded areas/ with .gitkeep"
    else
      fail "Could not scaffold areas/.gitkeep"
    fi
  fi

  SYSTEM_DIR="$VAULT_ROOT/system"
  if [ -d "$SYSTEM_DIR" ]; then
    skip "system/ already present"
  else
    if run mkdir -p "$SYSTEM_DIR/conventions" && run mkdir -p "$SYSTEM_DIR/templates"; then
      ok "Scaffolded system/ (conventions, templates)"
    else
      fail "Could not scaffold system/"
    fi
  fi

  # --- Claude Code plugin marketplace + plugin install -----------------------
  # The `@claude-code-workflows` suffix is a *marketplace* reference, not a
  # plugin scope. The marketplace must be registered (via `claude plugin
  # marketplace add`) before `claude plugin install` can resolve it. On a
  # fresh machine that marketplace isn't registered, so we add it first.
  # We explicitly detect existing registration via `claude plugin marketplace
  # list --json` rather than relying on `add` to be a no-op.
  CCW_MARKETPLACE_NAME="claude-code-workflows"
  CCW_MARKETPLACE_SOURCE="wshobson/agents"

  marketplace_registered() {
    # Returns 0 if $1 appears in `claude plugin marketplace list --json`.
    local name="$1"
    claude plugin marketplace list --json 2>/dev/null \
      | python3 -c "import json,sys
try:
    data=json.load(sys.stdin)
    sys.exit(0 if any(m.get('name')==\"$name\" for m in data) else 1)
except Exception:
    sys.exit(1)" >/dev/null 2>&1
  }

  CCW_MARKETPLACE_OK=0
  if marketplace_registered "$CCW_MARKETPLACE_NAME"; then
    skip "Claude Code marketplace '$CCW_MARKETPLACE_NAME' already registered"
    CCW_MARKETPLACE_OK=1
  else
    info "Registering Claude Code marketplace: $CCW_MARKETPLACE_NAME (source: $CCW_MARKETPLACE_SOURCE)"
    if [ "$DRY_RUN" = "1" ]; then
      dry_note "claude plugin marketplace add $CCW_MARKETPLACE_SOURCE"
      # Assume success for the rest of the dry-run flow.
      CCW_MARKETPLACE_OK=1
    else
      if claude plugin marketplace add "$CCW_MARKETPLACE_SOURCE"; then
        ok "Marketplace '$CCW_MARKETPLACE_NAME' registered"
        CCW_MARKETPLACE_OK=1
      else
        fail "Failed to register marketplace '$CCW_MARKETPLACE_NAME' from $CCW_MARKETPLACE_SOURCE"
        log "  Remediation: run 'claude plugin marketplace add $CCW_MARKETPLACE_SOURCE' manually, then re-run setup.sh."
      fi
    fi
  fi

  # Claude Code plugin (idempotent; claude plugin install no-ops if already installed).
  # Skipped if marketplace registration failed — without the marketplace, the
  # install would fail with a confusing "unknown marketplace" error.
  if [ "$CCW_MARKETPLACE_OK" = "1" ]; then
    info "Installing Claude Code plugin: javascript-typescript@$CCW_MARKETPLACE_NAME"
    if run claude plugin install "javascript-typescript@$CCW_MARKETPLACE_NAME"; then
      ok "Plugin installed (or already present)"
    else
      warn "Plugin install returned non-zero (may already be installed; check 'claude plugin list')"
    fi
  else
    warn "Skipping plugin install because marketplace '$CCW_MARKETPLACE_NAME' is not registered"
  fi

  # --- Personal branch (only if user is still on main and no personal branch yet)
  if [ "$DRY_RUN" = "1" ]; then
    dry_note "prompt for branch name and 'git checkout -b <name>'"
  else
    CURRENT_BRANCH="$(git -C "$VAULT_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
    if [ "$CURRENT_BRANCH" = "main" ]; then
      printf "  Your name for your personal branch (blank to skip): "
      read -r BRANCH_NAME
      if [ -n "$BRANCH_NAME" ]; then
        if git -C "$VAULT_ROOT" rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
          skip "Branch '$BRANCH_NAME' already exists; staying on $CURRENT_BRANCH"
        else
          git -C "$VAULT_ROOT" checkout -b "$BRANCH_NAME"
          ok "Created branch '$BRANCH_NAME'"
        fi
      else
        skip "Personal branch creation skipped (no name provided)"
      fi
    else
      skip "Already on branch '$CURRENT_BRANCH' (not main); skipping branch creation"
    fi
  fi

  # --- Add the shell alias for invoking Pam ----------------------------------
  if grep -q "alias pam=" "$SHELL_RC" 2>/dev/null; then
    skip "pam alias already present in $SHELL_RC"
  elif [ "$DRY_RUN" = "1" ]; then
    dry_note "append pam alias to $SHELL_RC"
  else
    {
      printf '\n%s\n' "# HQ setup: Pam alias"
      printf "%s\n" "alias pam='claude --dangerously-skip-permissions --agent pam'"
    } >> "$SHELL_RC"
    ok "pam alias added to $SHELL_RC (restart shell or 'source' it to use 'pam')"
  fi
fi

# ---------------------------------------------------------------------------
# Step 11: Verification grid
# ---------------------------------------------------------------------------

header "Verification"

# Re-check the actual world state, not just the install record (handles cases where
# a step "succeeded" but the binary still isn't on PATH for some reason).
verify_bin() {
  local label="$1" bin="$2" hint="$3"
  if command -v "$bin" >/dev/null 2>&1; then
    printf "  ${C_GREEN}OK${C_RESET}   %-22s (%s)\n" "$label" "$(command -v "$bin")"
    return 0
  else
    printf "  ${C_RED}FAIL${C_RESET} %-22s — %s\n" "$label" "$hint"
    return 1
  fi
}

verify_python_pkg() {
  local label="$1" pkg="$2" hint="$3"
  if python3 -c "import importlib.metadata; importlib.metadata.distribution('$pkg')" >/dev/null 2>&1; then
    printf "  ${C_GREEN}OK${C_RESET}   %-22s\n" "$label"
    return 0
  else
    printf "  ${C_RED}FAIL${C_RESET} %-22s — %s\n" "$label" "$hint"
    return 1
  fi
}

VERIFY_FAILED=0

verify_bin "gws-cli"     gws            "npm install -g @googleworkspace/cli" || VERIFY_FAILED=1
verify_bin "tavily-cli"  tvly           "curl -fsSL https://cli.tavily.com/install.sh | bash" || VERIFY_FAILED=1
verify_bin "agent-browser" agent-browser "npm install -g agent-browser && agent-browser install" || VERIFY_FAILED=1
verify_bin "soffice"     soffice        "brew install --cask libreoffice" || VERIFY_FAILED=1
verify_bin "pdftoppm"    pdftoppm       "brew install poppler" || VERIFY_FAILED=1

verify_python_pkg "python-pptx" python-pptx "pip3 install --user python-pptx" || VERIFY_FAILED=1
verify_python_pkg "Pillow"      Pillow      "pip3 install --user Pillow"      || VERIFY_FAILED=1
verify_python_pkg "lxml"        lxml        "pip3 install --user lxml"        || VERIFY_FAILED=1
verify_python_pkg "defusedxml"  defusedxml  "pip3 install --user defusedxml"  || VERIFY_FAILED=1
verify_python_pkg "pdf2image"   pdf2image   "pip3 install --user pdf2image"   || VERIFY_FAILED=1
verify_python_pkg "pypdf"       pypdf       "pip3 install --user pypdf"       || VERIFY_FAILED=1
verify_python_pkg "pdfplumber"  pdfplumber  "pip3 install --user pdfplumber"  || VERIFY_FAILED=1
verify_python_pkg "markitdown"  markitdown  "pip3 install --user 'markitdown[pptx]'" || VERIFY_FAILED=1

# pptxgenjs — Node library, no binary; check via npm ls
if npm ls -g --depth=0 pptxgenjs >/dev/null 2>&1; then
  printf "  ${C_GREEN}OK${C_RESET}   %-22s\n" "pptxgenjs"
else
  printf "  ${C_RED}FAIL${C_RESET} %-22s — npm install -g pptxgenjs\n" "pptxgenjs"
  VERIFY_FAILED=1
fi

# TAVILY_API_KEY — env or in rc
if [ -n "${TAVILY_API_KEY:-}" ]; then
  printf "  ${C_GREEN}OK${C_RESET}   %-22s (set in current env)\n" "TAVILY_API_KEY"
elif tavily_in_rc; then
  printf "  ${C_GREEN}OK${C_RESET}   %-22s (in $SHELL_RC; restart shell or source it)\n" "TAVILY_API_KEY"
else
  printf "  ${C_RED}FAIL${C_RESET} %-22s — set TAVILY_API_KEY in $SHELL_RC\n" "TAVILY_API_KEY"
  VERIFY_FAILED=1
fi

# pam alias — convenience command the final "Next" step tells the user to run.
if grep -q "alias pam=" "$SHELL_RC" 2>/dev/null; then
  printf "  ${C_GREEN}OK${C_RESET}   %-22s (in $SHELL_RC; restart shell or source it)\n" "pam alias"
else
  printf "  ${C_YELLOW}WARN${C_RESET} %-22s — not in $SHELL_RC; run 'claude --agent pam' directly\n" "pam alias"
fi

# Bundled OAuth client — shipped out-of-band (git-ignored), so a fresh clone may
# not have it. Report as informational rather than a hard failure.
if [ -f "$BUNDLED_GWS_CLIENT_SECRET" ]; then
  printf "  ${C_GREEN}OK${C_RESET}   %-22s (%s)\n" "gws bundled client" ".agents/auth/gws-client-secret.json"
else
  printf "  ${C_YELLOW}warn${C_RESET} %-22s — not present (git-ignored); ask the operator or run 'gws auth setup'\n" "gws bundled client"
fi

# gws auth
if command -v gws >/dev/null 2>&1; then
  GWS_STATUS_JSON="$(gws auth status 2>/dev/null | sed -n '/^{/,$p' || printf '{}')"
  GWS_TOKEN_OK=$(printf '%s' "$GWS_STATUS_JSON" | python3 -c "import json,sys;
try:
    d=json.load(sys.stdin); print('yes' if d.get('token_valid') else 'no')
except Exception:
    print('no')" 2>/dev/null || echo "no")
  if [ "$GWS_TOKEN_OK" = "yes" ]; then
    printf "  ${C_GREEN}OK${C_RESET}   %-22s\n" "gws auth"
  else
    printf "  ${C_RED}FAIL${C_RESET} %-22s — run 'gws auth login' (after 'gws auth setup' if first-time)\n" "gws auth"
    VERIFY_FAILED=1
  fi
fi

# claude-code-workflows marketplace
if command -v claude >/dev/null 2>&1; then
  if claude plugin marketplace list --json 2>/dev/null \
       | python3 -c "import json,sys
try:
    data=json.load(sys.stdin)
    sys.exit(0 if any(m.get('name')=='claude-code-workflows' for m in data) else 1)
except Exception:
    sys.exit(1)" >/dev/null 2>&1; then
    printf "  ${C_GREEN}OK${C_RESET}   %-22s\n" "ccw marketplace"
  else
    printf "  ${C_RED}FAIL${C_RESET} %-22s — run 'claude plugin marketplace add wshobson/agents'\n" "ccw marketplace"
    VERIFY_FAILED=1
  fi
fi

# IDENTITY.md present (safety net) — only meaningful when vault setup ran.
if [ "$SKIP_VAULT" != "1" ]; then
  if [ -f "$VAULT_ROOT/IDENTITY.md" ] || [ "$DRY_RUN" = "1" ]; then
    printf "  ${C_GREEN}OK${C_RESET}   %-22s\n" "IDENTITY.md"
  else
    printf "  ${C_YELLOW}warn${C_RESET} %-22s — not seeded; copy IDENTITY.example.md to IDENTITY.md\n" "IDENTITY.md"
  fi
fi

# ---------------------------------------------------------------------------
# Wrap-up
# ---------------------------------------------------------------------------

printf "\n"
if [ "$DRY_RUN" = "1" ]; then
  printf "${C_YELLOW}${C_BOLD}Dry run complete.${C_RESET} No real changes made. Re-run without --dry-run to apply.\n"
  exit 0
fi

if [ "$VERIFY_FAILED" = "0" ]; then
  printf "${C_GREEN}${C_BOLD}Setup complete.${C_RESET} All checks passed.\n\n"
  printf "Next:\n"
  printf "  1. Restart your shell (or run: source %s) to pick up PATH and TAVILY_API_KEY.\n" "$SHELL_RC"
  printf "  2. Open this vault (%s) in Obsidian.\n" "$VAULT_ROOT"
  printf "  3. Run 'pam' from this vault to talk to your assistant — she'll help you fill in IDENTITY.md on first run.\n"
  exit 0
else
  printf "${C_YELLOW}${C_BOLD}Setup finished with some failures (see above).${C_RESET}\n"
  printf "Fix the items marked FAIL and re-run %s — it is safe to re-run.\n" "$0"
  exit 1
fi
