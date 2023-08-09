#!/usr/bin/env bash
# Determine directory of this shell script.
dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

cd "$dir/bookmarks-source"
./elmmake.sh
cp index.html ../index.html

echo "Newest index is available at '$dir/index.html'"