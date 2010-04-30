# ~/.bashrc: executed by bash(1) for non-login shells.

#-----------------------------------------------------------------------------
# Test for an interactive shell
#-----------------------------------------------------------------------------

# This file is sourced by all *interactive* bash shells on startup, including
# some apparently interactive shells such as scp and rcp that can't tolerate
# any output. So, make sure this doesn't display anything or bad things will
# happen!
if [[ $- != *i* ]]; then
    return # Shell is non-interactive.  Be done now!
fi

#-----------------------------------------------------------------------------
# CONSTANTS
#-----------------------------------------------------------------------------

MY_SOURCE_DIR=${HOME}/.source

#-----------------------------------------------------------------------------
# Colors
#-----------------------------------------------------------------------------

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'       # No Color

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

# An example function
# function settitle() { echo -n "^[]2;$@^G^[]1;$@^G"; }

# Run when exitting shell
function _exit()
{
    # Delete files  for root
    if [[ "${USER}" == "root" ]]; then
        rm -f ${HOME}/.bash_history
        rm -f ${HOME}/.lesshst
        rm -f ${HOME}/.viminfo
    fi

    # Say something and be nice!
    echo -e "${RED}Bye!${NC}"
}
trap _exit EXIT

# Prepend directory to path if it exists
function prepend_to_path()
{
    if [[ -d "${1}" ]]; then
        PATH=${1}:${PATH}
    fi
}

# Append directory to path if it exists
function append_to_path()
{
    if [[ -d "${1}" ]]; then
        PATH=${PATH}:${1}
    fi
}

# Source script if it exists
function source_script()
{
    if [[ -e "${1}" ]]; then
        source ${1}
    fi
}

# Set ${1} to the first valid directory from the argument list. If none exists,
# set ${1} to "". The first argument should be a reference, not a variable. In
# other words, use VALID_DIR instead of ${VALID_DIR}. The remaining arguments
# should be normal variables.
#
# NOTE: This has not been tested on directories with spaces in them.
function first_valid_dir()
{
    dir=$1  # get reference
    eval "${dir}=\"\""  # clear any previous value
    shift  # remove ref from parameter list
    for arg in "$@"; do
        if [[ -d "${arg}" ]]; then
            eval "${dir}=\"${arg}\""  # assign new value
            return 0  # success
        fi
    done
    return -1  # failure
}

#-----------------------------------------------------------------------------
# Directory colors
#-----------------------------------------------------------------------------

# Enable colors for ls, etc. Prefer ~/.dir_colors
if [[ -f ~/.dir_colors ]]; then
    eval `dircolors -b ~/.dir_colors`
fi

#-----------------------------------------------------------------------------
# Terminal
#-----------------------------------------------------------------------------

# For OpenBSD, change terminal in order to use colors in termcap(5).
case ${OSTYPE} in
    openbsd*)
        case ${TERM} in
            xterm*|rxvt*|Eterm|aterm|kterm|gnome)
                TERM='xterm-xfree86'
                ;;
        esac
        ;;
esac

# Change the window title of X terminals 
case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
        PS1="\[\e]0;\w\a\]\n\[\e[0;32m\]\u@\h \[\e[1;30m\]\w\[\e[0m\]\n\$ "
        ;;
    screen)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
        ;;
esac

#-----------------------------------------------------------------------------
# History
#-----------------------------------------------------------------------------

# Don't put duplicate lines in the history
export HISTCONTROL=ignoredups
# Erase previous entries of command
export HISTCONTROL=erasedups

# Ignore some controlling instructions
export HISTIGNORE="[   ]*:&:bg:fg:exit"

#-----------------------------------------------------------------------------
# Bash completion
#-----------------------------------------------------------------------------

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# Source the bash completion profile
#case ${OSTYPE} in
#    linux-gnu) # Gentoo
#        [[ -f /etc/profile.d/bash-completion ]] &&
#        . /etc/profile.d/bash-completion
#        ;;
#    cygwin)
#        [[ -f /etc/bash_completion ]] &&
#        . /etc/bash_completion
#        ;;
#esac

#-----------------------------------------------------------------------------
# Vim
#-----------------------------------------------------------------------------

# Set editor
[[ -x /usr/bin/vim ]] && export EDITOR=vim

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------

# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# List the files in the directory with these options:
# - show all (-a)
# - classify (-F)
# - human-readable sizes (-h)
# - color
case ${OSTYPE} in
    linux-gnu|cygwin)
        alias ls='ls -Fh --color=auto'
        ;;
    darwin*)
        alias ls='ls -FhG'
        ;;
    openbsd*)
        alias ls='colorls -FhG'
        ;;
esac
alias la='ls -a'
alias ll='ls -l'

# Preserve mode, ownership, and timestamps
alias cp='cp -p'

# Use human-readable sizes (-h)
alias df='df -h'
alias du='du -h'

# Don't match binary files
# Show match in color
alias grep='grep -I --color'

# Use floating point math
alias bc='bc -l'

# Sourced commands
alias mkdircd='source ${MY_SOURCE_DIR}/mkdircd'

#-----------------------------------------------------------------------------
# Mac OS
#-----------------------------------------------------------------------------

# Tell 'tar' (and others?) to not include extended attributes when copying.
# This removes the annoying '._blah' file for every 'blah' file.
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true

#-----------------------------------------------------------------------------
# MacPorts
#-----------------------------------------------------------------------------

# According to (http://guide.macports.org/#installing.shell).
# These should come before normal paths for some apps. There was a problem with
# git-svn and Perl paths.
prepend_to_path "/opt/local/bin"
prepend_to_path "/opt/local/sbin"
prepend_to_path "/opt/local/share/man"

#-----------------------------------------------------------------------------
# Application-specific
#-----------------------------------------------------------------------------

# These are specific to certain applications I run. I generally want them only
# at certain sites and not polluting the environment at the others.

# Java 1.6 for Mac
case ${OSTYPE} in
    darwin*)
        alias java16='/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Commands/java'
        alias javac16='/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Commands/javac'
        ;;
esac

# TeX and LaTeX
prepend_to_path "/usr/texbin"

# GHC
append_to_path "/opt/ghc/bin"
append_to_path "$HOME/.ghc-config/ghc/bin"
[[ -x "/opt/ghc/bin" ]] && /opt/ghc/bin/ghc-config -i
# TODO: Change Bean to use the above for GHC
append_to_path "/usr/local/ghc-6.8.2-ppc-tiger/bin"

# Cabalized apps
prepend_to_path ${HOME}/.cabal/bin

#-----------------------------------------------------------------------------
# Nix
#-----------------------------------------------------------------------------

# Set up the Nix environment and prepend the paths
source_script /nix/etc/profile.d/nix.sh

#-----------------------------------------------------------------------------
# Common private directories (should be almost last)
#-----------------------------------------------------------------------------

# Set PATH to include my private bin if it exists
[[ -d "${HOME}/bin" ]] && PATH=${HOME}/bin:${PATH}

# Set MANPATH to include my private man if it exists
[[ -d "${HOME}/man" ]] && MANPATH=${HOME}/man:${MANPATH}

# Set INFOPATH to include my private info if it exists
[[ -d "${HOME}/info" ]] && INFOPATH=${HOME}/info:${INFOPATH}

#-----------------------------------------------------------------------------
# Final exports
#-----------------------------------------------------------------------------

# Reset PATH for root
if [[ "${USER}" == "root" ]]; then
    PATH=/sbin:/usr/sbin:${HOME}/bin:/usr/local/bin:/bin:/usr/bin
fi

export PATH MANPATH INFOPATH
