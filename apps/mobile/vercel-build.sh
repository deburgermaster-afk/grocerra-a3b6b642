#!/bin/sh
# Builds the Flutter app for the web on Vercel (its build image has no Flutter SDK, so fetch it first).
set -e
FLUTTER_DIR="$HOME/flutter"
if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
flutter config --no-analytics --enable-web
flutter pub get
flutter build web --release
