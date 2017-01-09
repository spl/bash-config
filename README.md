# Introduction

This repository contains all the configuration files that I (Sean Leather) use
with Bash across various platforms.

# Usage

Run the [`install.sh`](./install.sh) script.

## Path

Update your `$PATH` if it does not already have this:

```
$ export PATH=$HOME/bin:$PATH
```

## Local Bash Configuration

Put your local (machine-specific) Bash configuration in `$HOME/.bashrc.local`.

## Bash Completion

If you're using bash completion, make a symlink from the global
`bash_completion` file to `.bash_completion.local` in `$HOME`. You can use the
`make_symlink` function in `$HOME/.bashrc.local` to ensure this link exists at
shell startup.
