#!/bin/bash

# Build Jekyll documentation
# This script must be run from the project root

set -e

DOCS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../docs" && pwd)"

echo "Building Jekyll site in $DOCS_DIR..."

cd "$DOCS_DIR"

# Unset any parent BUNDLE environment variables to avoid conflicts
unset BUNDLE_GEMFILE
unset BUNDLE_PATH
unset BUNDLE_BIN

# Always install/update dependencies to ensure correct gems
echo "Installing/updating dependencies..."
bundle install --path vendor/bundle

bundle exec jekyll build

echo "Build complete! Output in $DOCS_DIR/_site"
