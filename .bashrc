# ~/.bashrc:

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

# Append directory to path if it exists
function append_to_path()
{
    if [[ -d "${1}" ]]; then
        PATH=${PATH}:${1}
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
# X terminal
#-----------------------------------------------------------------------------

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
        alias ls='ls -aFh --color=auto'
        ;;
    darwin*)
        alias ls='ls -aFhG'
        ;;
esac
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

#-----------------------------------------------------------------------------
# Common private directories
#-----------------------------------------------------------------------------

# Set PATH to include my private bin if it exists
[[ -d "${HOME}/bin" ]] && PATH=${HOME}/bin:${PATH}

# Set MANPATH to include my private man if it exists
[[ -d "${HOME}/man" ]] && MANPATH=${HOME}/man:${MANPATH}

# Set INFOPATH to include my private info if it exists
[[ -d "${HOME}/info" ]] && INFOPATH=${HOME}/info:${INFOPATH}

#-----------------------------------------------------------------------------
# Site-specific
#-----------------------------------------------------------------------------

# This is where I put stuff specific to each site that uses this .bashrc.

# Set up paths for MacPorts (http://guide.macports.org/#installing.shell)
[[ -d "/opt/local/bin" ]] && PATH=${PATH}:/opt/local/bin
[[ -d "/opt/local/sbin" ]] && PATH=${PATH}:/opt/local/sbin
[[ -d "/opt/local/share/man" ]] && MANPATH=${MANPATH}:/opt/local/share/man

#-----------------------------------------------------------------------------
# Application-specific
#-----------------------------------------------------------------------------

# These are specific to certain applications I run. I generally want them only
# at certain sites and not polluting the environment at the others.

# GHC -- Test for directory. This may be replaced with something better later.
GHC_PATH_VAL=/usr/local/ghc-head/bin
GHC_PATH_BEAN=/usr/local/ghc-6.8.2-ppc-tiger/bin
first_valid_dir GHC_PATH ${GHC_PATH_VAL} ${GHC_PATH_BEAN}
append_to_path ${GHC_PATH}

# Darcs -- Test for directory
DARCS_PATH_VAL=/usr/local/darcs-1.0.9rc2-i386-tiger/bin
DARCS_PATH_BEAN=/usr/local/darcs-1.0.9rc2-ppc-tiger/bin
first_valid_dir DARCS_PATH ${DARCS_PATH_BEAN} ${DARCS_PATH_VAL}
append_to_path ${DARCS_PATH}

# Happy -- Test for directory
HAPPY_PATH_DARCS=/usr/local/happy-darcs/bin
HAPPY_PATH_1_17=/usr/local/happy-1.17/bin
first_valid_dir HAPPY_PATH ${HAPPY_PATH_DARCS} ${HAPPY_PATH_1_17}
append_to_path ${HAPPY_PATH}

# Alex -- Test for directory
ALEX_PATH_DARCS=/usr/local/alex-darcs/bin
ALEX_PATH_2_2=/usr/local/alex-2.2/bin
first_valid_dir ALEX_PATH ${ALEX_PATH_DARCS} ${ALEX_PATH_2_2}
append_to_path ${ALEX_PATH}

# lhs2tex -- Test for directory
LHS2TEX_PATH=/usr/local/lhs2tex-1.13/bin
append_to_path ${LHS2TEX_PATH}

# local cabal -- Test for directory
CABAL_PATH=${HOME}/.cabal/bin
append_to_path ${CABAL_PATH}

# local agda -- Test for directory
AGDA_PATH=/usr/local/agda-darcs/bin
append_to_path ${AGDA_PATH}

#-----------------------------------------------------------------------------
# Final exports
#-----------------------------------------------------------------------------

# Reset PATH for root
if [[ "${USER}" == "root" ]]; then
    PATH=/sbin:/usr/sbin:${HOME}/bin:/usr/local/bin:/bin:/usr/bin
fi

export PATH MANPATH INFOPATH
