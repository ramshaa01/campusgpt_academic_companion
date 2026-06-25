#!/bin/bash
set -e

echo "Downloading Flutter..."
git clone --depth 1 https://github.com/flutter/flutter.git -b stable

echo "Adding Flutter to PATH..."
export PATH="$PATH:$(pwd)/flutter/bin"

echo "Building Flutter Web App (HTML renderer for smaller bundle)..."
flutter build web --release --web-renderer html
