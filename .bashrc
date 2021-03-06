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
FG_LTGRAY='\e[0;37m'

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

# Append directory, if it exists, to MANPATH
function append_to_manpath()
{
    if [[ -d "${1}" ]]; then
        MANPATH=${MANPATH}:${1}
    fi
}

# Append directory, if it exists, to INFOPATH
function append_to_infopath()
{
    if [[ -d "${1}" ]]; then
        INFOPATH=${INFOPATH}:${1}
    fi
}

# Source script if it exists
function source_script()
{
    if [[ -r "${1}" ]]; then
        source "${1}"
    fi
}

# Source all scripts in directory if the directory exists
function source_dir()
{
    if [[ -d "${1}" ]]; then
        for f in "$(/bin/ls ${1})"; do
            source_script "${1}/${f}"
        done
    fi
}

# Make a symbolic link if the link does not already exist and the source exists
function make_symlink()
{
    if [[ ! (-f "${2}") && -f "${1}" ]]; then
        ln -s "${1}" "${2}"
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

# Clear the screen and scrollback buffer of the terminal
# https://stackoverflow.com/a/1348624/545794
# https://apple.stackexchange.com/a/318217/62339
function cls()
{
    printf '\033[2J\033[3J\033[1;1H'
}

#-----------------------------------------------------------------------------
# Path
#-----------------------------------------------------------------------------

# Reset
PATH="/bin"

# Add directories
prepend_to_path "/usr/bin"
prepend_to_path "/usr/local/sbin"
prepend_to_path "/usr/local/bin"

#-----------------------------------------------------------------------------
# Readline key bindings
#-----------------------------------------------------------------------------

bind '"\C-b": kill-word'

#-----------------------------------------------------------------------------
# grep
#-----------------------------------------------------------------------------

if [[ -f "/usr/bin/grep" ]]; then
    export GREP=/usr/bin/grep
elif [[ -f "/bin/grep" ]]; then
    export GREP=/bin/grep
fi

#-----------------------------------------------------------------------------
# Directory colors
#-----------------------------------------------------------------------------

# Enable colors for ls, etc. Prefer $HOME/.dir_colors
if [[ -f $HOME/.dir_colors ]]; then
    eval `dircolors -b $HOME/.dir_colors`
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

# History controls: a list of patterns, separated by colons (:), which can have
# the following values:
#
#   ignorespace:
#      lines beginning with a space are not entered into the history list.
#
#   ignoredups:
#      lines matching the last history line are not entered.
#
#   ignoreboth:
#       enables both ignorespace and ignoredups.
#
#   erasedups:
#       all previous lines matching the current line are removed from the
#       history list before the line is saved.

export HISTCONTROL="ignoreboth:erasedups"

# Ignore the listed commands
export HISTIGNORE="exit:[bf]g:reset:clear:cls:rm *:g add *:git add *:g rm *:g ci: git commit:g push: git push"

# Append to the history file, don't overwrite it
shopt -s histappend

#-----------------------------------------------------------------------------
# Bash configuration
#-----------------------------------------------------------------------------

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

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

# Source the local bash_completion symlink
source_script $HOME/.bash_completion.local

# Source local bash completion scripts
source_dir $HOME/.bash_completion.d

#-----------------------------------------------------------------------------
# Prompt
#-----------------------------------------------------------------------------

function set_prompt() {
    local c_reset="\[${CRESET}\]"
    local c_userhost="\[${FG_GREEN}\]"
    local c_pwd="\[${FG_CYAN}\]"
    local c_time="\[${FG_LTGRAY}\]"
    local c_jobs="\[${FG_PURPLE}\]"

    # Title bar
    local prefix="\[${TERM_ESC}\W [\u@\h]\a\]"

    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        local c_ssh="\[${FG_PURPLE}\]"
        prefix+="${c_ssh}[ssh]${c_reset} "
    fi

    # nix-shell
    if [[ "$IN_NIX_SHELL" -eq 1 ]]; then
        local c_nix="\[${FG_RED}\]"
        prefix+="${c_nix}[nix]${c_reset} "
    fi

    case ${TERM} in
        xterm*|rxvt*|Eterm|aterm|kterm|gnome)
            ;;
        screen*)
            # [tmux] or [screen]
            local c_screen="\[${FG_BLUE}\]"
            if [ -n "$TMUX" ]; then
                prefix+="${c_screen}[tmux]${c_reset} "
            else
                prefix+="${c_screen}[screen:${WINDOW}]${c_reset} "
            fi
            ;;
    esac

    # Background jobs
    local njobs="$(jobs -p | wc -l)"
    if [[ "${njobs}" -gt 0 ]]; then
        prefix+="${c_jobs}[${njobs##* }]${c_reset} "
    fi

    # Prompt: 2 lines
    local top="\n$prefix${c_userhost}\u@\h${c_reset}:${c_pwd}\w${c_reset}"
    local bottom="\n${c_time}$(date +%H:%M:%S)${c_reset} \$ "

    if type -t __git_ps1 | ${GREP} -q "function"; then
        # The completion file must be sourced before using __git_ps1.
        __git_ps1 "${top}" "${bottom}"
    else
        export PS1="${top}${bottom}"
    fi
}

export PROMPT_COMMAND=set_prompt

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

# If you would like a colored hint about the current dirty state, set
# GIT_PS1_SHOWCOLORHINTS to a nonempty value. The colors are based on the
# colored output of "git status -sb" and are available only when using __git_ps1
# for PROMPT_COMMAND or precmd.
GIT_PS1_SHOWCOLORHINTS=1

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
# Environment
#-----------------------------------------------------------------------------

# Set editor
[[ -x /usr/bin/vim ]] && export EDITOR=vim

# less options:
#   -F or --quit-if-one-screen
#      Causes less to automatically exit if the entire file can be displayed on
#      the first screen.
#
#   -R or --RAW-CONTROL-CHARS
#      Like -r, but only ANSI "color" escape sequences are output in "raw" form.
#
#   -S or --chop-long-lines
#      Causes lines longer than the screen width to be chopped (truncated)
#      rather than wrapped.
#
#   -X or --no-init
#      Disables sending the termcap initialization and deinitialization strings
#      to the terminal.
#
# Note:
#   Using -F without -X was an issue in versions of less < 530. Either you got
#   --quit-if-one-screen or --no-init, not both for files that fit in one
#   screen. Since -X prevents mouse scrolling, I don't use it. But this means I
#   should use a version of less >= 530.
#
#   See https://unix.stackexchange.com/a/432254/137060
export LESS=FRS

# ack pager
export ACK_PAGER=less

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------

# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Directory listing

case ${OSTYPE} in
    linux*)
        alias ls='ls -Fh --color=auto'
        ;;
    darwin*)
        alias ls='ls -FhG'
        ;;
esac

alias ll='ls -al'

# Preserve mode, ownership, and timestamps
alias cp='cp -p'

# Use human-readable sizes (-h)
alias df='df -h'
alias du='du -h'

# Use floating point math
alias bc='bc -l'

# ssh/scp and ignore the host
alias sshNoHostChecking='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias scpNoHostChecking='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# ack for Haskell
hash ack 2>/dev/null && alias ackhs='ack --haskell'

# Delete docker images or processes or both
hash docker 2>/dev/null && alias docker-clean-images='X=$(docker images -q -f dangling=true) [ -z "$X" ] || docker rmi $X'
hash docker 2>/dev/null && alias docker-clean-processes='X=$(docker ps -a -q -f status=exited) [ -z "$X" ] || docker rm -v $X'
hash docker 2>/dev/null && alias docker-clean-all='docker-clean-images; docker-clean-processes'

# Git alias with bash completion
hash git &> /dev/null && alias g='git'
source_script /usr/share/bash-completion/completions/git
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi

# Travis gem bash completion
source_script $HOME/.travis/travis.sh

# Google Chrome
[[ -d "/Applications/Google Chrome.app" ]] && alias chrome='open -a Google\ Chrome'

#-----------------------------------------------------------------------------
# Local configuration
#-----------------------------------------------------------------------------

source_script $HOME/.bashrc.local

#-----------------------------------------------------------------------------
# Common private directories (should be almost last)
#-----------------------------------------------------------------------------

# Add user bin directories to PATH
prepend_to_path "${HOME}/.cabal/bin"
prepend_to_path "${HOME}/.local/bin"
prepend_to_path "${HOME}/.cargo/bin"
prepend_to_path "${HOME}/bin"

# Add my home directories to MANPATH and INFOPATH
append_to_manpath "${HOME}/man"
append_to_infopath "${HOME}/info"

#-----------------------------------------------------------------------------
# Final exports
#-----------------------------------------------------------------------------

# Reset PATH for root
if [[ "${USER}" == "root" ]]; then
    PATH=/sbin:/usr/sbin:${HOME}/bin:/usr/local/sbin:/usr/local/bin:/bin:/usr/bin
fi

export PATH MANPATH INFOPATH

