#!/usr/bin/env bash
# Determine directory of this shell script.
dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# Install elm if it's not installed already
brew list elm ||  brew install elm

#source: https://stackoverflow.com/questions/8557202/how-do-i-write-a-bash-script-to-download-and-unzip-file-on-a-mac
unzip-from-link() {
 local download_link=$1; shift || return 1
 local temporary_dir

 temporary_dir=$(mktemp -d) \
 && curl -LO "${download_link:-}" \
 && unzip -d "$temporary_dir" \*.zip \
 && rm -rf \*.zip \
 && mv "$temporary_dir"/* ${1:-"$HOME/Downloads"} \
 && rm -rf $temporary_dir
}

rm -rf "$dir/bookmarks-source"
unzip-from-link "https://github.com/wwbakker/bookmarks/archive/refs/heads/master.zip" "$dir/bookmarks-source"
rm "$dir/bookmarks-source/src/PrivateBookmarks.elm"
ln -s "$dir/PrivateBookmarks.elm" "$dir/bookmarks-source/src/PrivateBookmarks.elm"