#!/bin/sh -e

# Symbolic link with force and don't follow existing link
LN="ln -nsf --"

# mkdir if the directory doesn't alread exist
MKDIR="mkdir -p --"

# Full directory path of script
SRC=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

$LN "$SRC/.bash_logout" "$HOME/"
$LN "$SRC/.bash_profile" "$HOME/"
$LN "$SRC/.bashrc" "$HOME/"
$LN "$SRC/.inputrc" "$HOME/"

# Make user bin directory
USER_BIN_DIR=$HOME/bin
$MKDIR "$USER_BIN_DIR"

$LN "$SRC/grep" "$USER_BIN_DIR/"

# Make user bash completion directory
USER_BASH_COMPLETION_DIR=$HOME/.bash_completion.d
$MKDIR "$USER_BASH_COMPLETION_DIR"

$LN "$SRC/cabal" "$USER_BASH_COMPLETION_DIR/"
