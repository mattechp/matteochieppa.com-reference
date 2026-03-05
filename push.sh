#!/usr/bin/env bash
# Push updates to mattechp/matteochieppa.com-reference
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
REMOTE="git@github.com:mattechp/matteochieppa.com-reference.git"
COMMIT_MSG="logs: sync"

cd "$REPO_DIR"

if [ ! -d .git ]; then
  git init
  git remote add origin "$REMOTE"
fi

# Pull before push to avoid overwriting dashboard-origin changes (when remote has main)
if git remote get-url origin &>/dev/null && git ls-remote --exit-code origin main &>/dev/null; then
  git fetch origin main && git rebase origin/main
fi

# Add all changes (Git will automatically ignore .gitignore and push.sh now)
git add .

if git diff --staged --quiet; then
  echo "No changes to push."
  exit 0
fi

git commit -m "$COMMIT_MSG"
git branch -M main
git push -u origin main

echo "Pushed README.md, logs/, and blog/ to mattechp/matteochieppa.com-reference."