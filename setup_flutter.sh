#!/bin/bash
set -e

# Install Flutter SDK (latest stable)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

# Install dependencies
flutter pub get
