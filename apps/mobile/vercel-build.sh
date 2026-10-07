#!/bin/sh
# Builds the Flutter app for the web on Vercel (its build image has no Flutter SDK, so fetch it first).
# Runs under plain `sh`, so keep everything POSIX.
set -e

# Pin to the toolchain the app is developed against (Flutter 3.47.6 / Dart 3.13.5)
# so the deployed bundle comes out of the same compiler as the build that was
# verified against the Figma frames. Override with FLUTTER_VERSION if needed.
FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.6}"
FLUTTER_DIR="$HOME/flutter"
if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1 "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
export PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"

flutter config --no-analytics --enable-web
flutter pub get

# Build-time configuration. Public values only — nothing secret may ship in a
# browser bundle. Sources, in order of precedence:
#   1. config/vercel.defines.json, a committed --dart-define-from-file bundle;
#   2. Vercel project env vars, under either the GROCERRA_* names or the
#      shared SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY names.
DEFINES=""
if [ -f config/vercel.defines.json ]; then
  echo "Config: config/vercel.defines.json"
  DEFINES="--dart-define-from-file=config/vercel.defines.json"
else
  BASE_URL="${GROCERRA_API_BASE_URL:-${SUPABASE_URL:-}}"
  ANON_KEY="${GROCERRA_SUPABASE_ANON_KEY:-${SUPABASE_PUBLISHABLE_KEY:-}}"
  if [ -n "$BASE_URL" ] && [ -n "$ANON_KEY" ]; then
    echo "Config: Supabase settings from the Vercel environment"
    DEFINES="--dart-define=GROCERRA_API_BASE_URL=$BASE_URL"
    DEFINES="$DEFINES --dart-define=GROCERRA_SUPABASE_ANON_KEY=$ANON_KEY"
    DEFINES="$DEFINES --dart-define=GROCERRA_OAUTH_ENABLED=${GROCERRA_OAUTH_ENABLED:-false}"
    if [ -n "${GROCERRA_OAUTH_REDIRECT:-}" ]; then
      DEFINES="$DEFINES --dart-define=GROCERRA_OAUTH_REDIRECT=$GROCERRA_OAUTH_REDIRECT"
    fi
  else
    echo "Config: none in the environment, building with app defaults"
  fi
fi

# shellcheck disable=SC2086 # $DEFINES is a deliberately unquoted word list
flutter build web --release $DEFINES
