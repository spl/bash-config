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
# Colors
#-----------------------------------------------------------------------------

TERM_ESC='\e]0;'

# Reset colors
CRESET='\e[0m'

# Regular foreground
FG_BLACK='\e[0;30m'
FG_RED='\e[0;31m'
FG_GREEN='\e[0;32m'
FG_YELLOW='\e[0;33m'
FG_BLUE='\e[0;34m'
FG_PURPLE='\e[0;35m'
FG_CYAN='\e[0;36m'
FG_WHITE='\e[0;37m'

# Bold foreground
FG_BBLACK='\e[1;30m'
FG_BRED='\e[1;31m'
FG_BGREEN='\e[1;32m'
FG_BYELLOW='\e[1;33m'
FG_BBLUE='\e[1;34m'
FG_BPURPLE='\e[1;35m'
FG_BCYAN='\e[1;36m'
FG_BWHITE='\e[1;37m'

# Underline foreground
FG_UBLACK='\e[4;30m'
FG_URED='\e[4;31m'
FG_UGREEN='\e[4;32m'
FG_UYELLOW='\e[4;33m'
FG_UBLUE='\e[4;34m'
FG_UPURPLE='\e[4;35m'
FG_UCYAN='\e[4;36m'
FG_UWHITE='\e[4;37m'

# High intensty foreground
FG_IBLACK='\e[0;90m'
FG_IRED='\e[0;91m'
FG_IGREEN='\e[0;92m'
FG_IYELLOW='\e[0;93m'
FG_IBLUE='\e[0;94m'
FG_IPURPLE='\e[0;95m'
FG_ICYAN='\e[0;96m'
FG_IWHITE='\e[0;97m'

# Bold high intensty foreground
FG_BIBLACK='\e[1;90m'
FG_BIRED='\e[1;91m'
FG_BIGREEN='\e[1;92m'
FG_BIYELLOW='\e[1;93m'
FG_BIBLUE='\e[1;94m'
FG_BIPURPLE='\e[1;95m'
FG_BICYAN='\e[1;96m'
FG_BIWHITE='\e[1;97m'

# Regular background
BG_BLACK='\e[40m'
BG_RED='\e[41m'
BG_GREEN='\e[42m'
BG_YELLOW='\e[43m'
BG_BLUE='\e[44m'
BG_PURPLE='\e[45m'
BG_CYAN='\e[46m'
BG_WHITE='\e[47m'

# High intensty background
BG_IBLACK='\e[0;100m'
BG_IRED='\e[0;101m'
BG_IGREEN='\e[0;102m'
BG_IYELLOW='\e[0;103m'
BG_IBLUE='\e[0;104m'
BG_IPURPLE='\e[10;95m'
BG_ICYAN='\e[0;106m'
BG_IWHITE='\e[0;107m'

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
    echo -e "${FG_RED}Bye!${CRESET}"
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
    if [[ -f "${1}" ]]; then
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
# Path
#-----------------------------------------------------------------------------

# Reset
PATH="/bin"

# Add directories
prepend_to_path "/usr/bin"
prepend_to_path "/usr/local/bin"

#-----------------------------------------------------------------------------
# Directory colors
#-----------------------------------------------------------------------------

# Enable colors for ls, etc. Prefer ~/.dir_colors
if [[ -f ~/.dir_colors ]]; then
    eval `dircolors -b ~/.dir_colors`
fi

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

# See .bashrc.local for the bash completion profile

#-----------------------------------------------------------------------------
# Prompt
#-----------------------------------------------------------------------------

function set_prompt() {
  local PROMPT_TERM="\[${TERM_ESC}\w [\u@\h]\a\]"
  local PROMPT_USERHOST="\[${FG_GREEN}\]\u@\h"
  local PROMPT_PWD="\[${FG_CYAN}\]\w"
  local PROMPT_RESET="\[${CRESET}\]"
  local PROMPT_GIT=""

  # The completion file should be sourced before this.
  if type -t __git_ps1 | grep -q "^function$"
  then
    PROMPT_GIT="${FG_PURPLE}\$(__git_ps1 '(%s)')"
  fi

  case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome)
      PS1="\n${PROMPT_TERM}${PROMPT_USERHOST}:${PROMPT_PWD} ${PROMPT_GIT}${PROMPT_RESET}\n\$ "
      ;;
    screen)
      PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
      ;;
  esac
}
set_prompt
unset set_prompt

#-------------------------------------------------------------------------------
# Git prompt
#-------------------------------------------------------------------------------

# If you set GIT_PS1_SHOWDIRTYSTATE to a nonempty value, unstaged (*) and staged
# (+) changes will be shown next to the branch name.  You can configure this
# per-repository with the bash.showDirtyState variable, which defaults to true
# once GIT_PS1_SHOWDIRTYSTATE is enabled.
GIT_PS1_SHOWDIRTYSTATE=1

# You can also see if currently something is stashed, by setting
# GIT_PS1_SHOWSTASHSTATE to a nonempty value. If something is stashed, then a
# '$' will be shown next to the branch name.
GIT_PS1_SHOWSTASHSTATE=1

# If you would like to see if there're untracked files, then you can set
# GIT_PS1_SHOWUNTRACKEDFILES to a nonempty value. If there're untracked files,
# then a '%' will be shown next to the branch name.
#GIT_PS1_SHOWUNTRACKEDFILES=1

# If you would like to see the difference between HEAD and its upstream, set
# GIT_PS1_SHOWUPSTREAM="auto".  A "<" indicates you are behind, ">" indicates
# you are ahead, and "<>" indicates you have diverged.  You can further control
# behaviour by setting GIT_PS1_SHOWUPSTREAM to a space-separated list of values:
#   verbose       show number of commits ahead/behind (+/-) upstream
#   legacy        don't use the '--count' option available in recent versions
#                 of git-rev-list
#   git           always compare HEAD to @{upstream}
#   svn           always compare HEAD to your SVN upstream
# By default, __git_ps1 will compare HEAD to your SVN upstream if it can find
# one, or @{upstream} otherwise.  Once you have set GIT_PS1_SHOWUPSTREAM, you
# can override it on a per-repository basis by setting the bash.showUpstream
# config variable.
GIT_PS1_SHOWUPSTREAM="auto"

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

# Directory listing
alias ll='ls -al'

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
# Local configuration
#-----------------------------------------------------------------------------

source_script .bashrc.local

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
