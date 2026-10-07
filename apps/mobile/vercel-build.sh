#!/usr/bin/env bash
#
# GROCERRA user app — Vercel build (Flutter web).
#
# The Vercel build image ships Node and Python, not the Flutter SDK, so a
# pinned stable toolchain is fetched first and the web bundle is compiled from
# source. The pin matches the SDK the app is developed against (Flutter
# 3.47.6 / Dart 3.13.5) so the deployed pixels come out of the same compiler
# as the build that was verified against the Figma frames.
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.6}"
FLUTTER_ROOT="${FLUTTER_ROOT:-${HOME}/flutter}"
PUB_CACHE="${PUB_CACHE:-${HOME}/.pub-cache}"
export FLUTTER_ROOT PUB_CACHE
export PATH="${FLUTTER_ROOT}/bin:${PATH}"

if [ ! -x "${FLUTTER_ROOT}/bin/flutter" ]; then
  echo "==> Installing Flutter ${FLUTTER_VERSION}"
  rm -rf "${FLUTTER_ROOT}"
  git clone --quiet --depth 1 --branch "${FLUTTER_VERSION}" \
    https://github.com/flutter/flutter.git "${FLUTTER_ROOT}"
fi

echo "==> Toolchain"
flutter config --no-analytics >/dev/null 2>&1 || true
flutter --version

echo "==> Dependencies"
flutter pub get

# Build-time configuration — public values only, nothing secret belongs in a
# browser bundle. Sources, in order of precedence:
#   1. config/vercel.defines.json, a committed --dart-define-from-file bundle;
#   2. Vercel project env vars, under either the GROCERRA_* names or the
#      shared SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY names.
DEFINES=()
if [ -f config/vercel.defines.json ]; then
  echo "==> Config: config/vercel.defines.json"
  DEFINES+=(--dart-define-from-file=config/vercel.defines.json)
else
  BASE_URL="${GROCERRA_API_BASE_URL:-${SUPABASE_URL:-}}"
  ANON_KEY="${GROCERRA_SUPABASE_ANON_KEY:-${SUPABASE_PUBLISHABLE_KEY:-}}"
  if [ -n "${BASE_URL}" ] && [ -n "${ANON_KEY}" ]; then
    echo "==> Config: Supabase settings from the Vercel environment"
    DEFINES+=(--dart-define="GROCERRA_API_BASE_URL=${BASE_URL}")
    DEFINES+=(--dart-define="GROCERRA_SUPABASE_ANON_KEY=${ANON_KEY}")
    DEFINES+=(--dart-define="GROCERRA_OAUTH_ENABLED=${GROCERRA_OAUTH_ENABLED:-false}")
    if [ -n "${GROCERRA_OAUTH_REDIRECT:-}" ]; then
      DEFINES+=(--dart-define="GROCERRA_OAUTH_REDIRECT=${GROCERRA_OAUTH_REDIRECT}")
    fi
  else
    echo "==> Config: none in the environment, building with app defaults"
  fi
fi

echo "==> Building web release"
flutter build web --release ${DEFINES[@]+"${DEFINES[@]}"}

echo "==> Built $(du -sh build/web | cut -f1) into build/web"
