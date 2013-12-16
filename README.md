Introduction
------------

This repository contains all the configuration files that I (Sean Leather) use
with Bash across various platforms.

Usage
-----

Create the appropriate links from $HOME to each of the files in
this repository.

 * `.bashrc`       - the primary configuration file
 * `.bash_logout`  - logout script
 * `.bash_profile` - loads `.bashrc`
 * `.inputrc`      - readline configuration file

Create a `.bashrc.local` file for the machine-local configuration.

If you are using *bash_completion*, make a symlink from the global
`bash_completion` file to `.bash_completion.local` in $HOME. You can use
`make_symlink` in your `.bashrc.local` to ensure this link exists at shell
startup.

