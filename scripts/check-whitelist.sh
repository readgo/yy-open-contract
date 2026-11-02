#!/bin/sh
# Whitelist gate for the contract repository.
#
# The point of a separate contract repo is neutrality: it is read by both the
# backend and the frontend, and neither owns it. The moment implementation code
# lands here, that neutrality is gone and the repository turns into a fourth
# language project that has to be built, tested and released.
#
# Allowed: *.yaml, *.json, *.md, gen/**, go.mod, go.sum, scripts/**, .gitignore
# Rejected: everything else, in particular cmd/, internal/, pkg/, src/,
#           package.json, Dockerfile and any .go file outside gen/.
#
# Usage: scripts/check-whitelist.sh [rev-range]
#        default range is the whole tracked file set.
set -eu

cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

if [ $# -gt 0 ]; then
    files=$(git diff --name-only "$@")
else
    files=$(git ls-files)
fi

fail=0

for f in $files; do
    case "$f" in
        gen/*.go|gen/**)
            continue
            ;;
        *.yaml|*.yml|*.json|*.md|*.txt)
            continue
            ;;
        go.mod|go.sum|.gitignore)
            continue
            ;;
        scripts/*)
            continue
            ;;
        *)
            echo "FAIL  not allowed in the contract repo: $f" >&2
            fail=1
            ;;
    esac
done

if [ "$fail" -ne 0 ]; then
    echo "" >&2
    echo "contract whitelist violated; see README.md" >&2
    exit 1
fi

echo "contract whitelist passed"
