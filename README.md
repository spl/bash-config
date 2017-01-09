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

If you're using Bash completion, add one of the following lines with the global
completion file (e.g. `/usr/local/etc/bash_completion`) to your
`$HOME/.bashrc.local`:

1. source the global completion file:

   ```sh
   source_script /usr/local/etc/bash_completion
   ```

2. make a symbolic link to `$HOME/.bash_completion.local`:

   ```sh
   make_symlink /usr/local/etc/bash_completion "$HOME/.bashrc.local"
   ```
