#!/usr/bin/env bash

set -euox pipefail

cd "$(dirname "$0")"

# Update the local repository if not running in a GitHub Action
if [ -z "${GITHUB_ACTIONS:-}" ]; then
    git pull --rebase origin
fi

# Download the latest rumen-cli executable if it does not exist
if ! [ -x ./rumen-cli.exe ]; then
    echo "Downloading rumen-cli..."
    curl -L -o rumen-cli.exe https://punchagan.github.io/rumen/scripts/rumen-cli.exe
    chmod +x rumen-cli.exe
fi

./rumen-cli.exe fetch

if [ -n "$(git status --porcelain -- ./articles/content)" ]; then
    git add articles/
    # Set committer information if running in a GitHub Action
    if [ -n "${GITHUB_ACTIONS:-}" ]; then
        git config user.email "rumen.fetch@example.com"
        git config user.name "Rumen CLI Fetch"
    fi
    git commit -m "Fetch article content"
    git push
fi
