# ~/.bashrc: executed by bash(1) for non-login shells.

set -o vi
# Run fastfetch only once per login or graphical session, not in every new terminal/tab.
# This uses a lock file in /tmp that is unique per session:
# - If $XDG_SESSION_ID is set (most modern desktops), use it for session-uniqueness.
# - Else if $DISPLAY is set (X11), use it for graphical session-uniqueness.
# - Else fallback to per-user (may run once per TTY).
if [ -n "$XDG_SESSION_ID" ]; then
    # Use session ID for lock file
    FASTFETCH_LOCKFILE="/tmp/.fastfetch-ran-$USER-$XDG_SESSION_ID"
elif [ -n "$DISPLAY" ]; then
    # Use X11 display for lock file
    FASTFETCH_LOCKFILE="/tmp/.fastfetch-ran-$USER-$(echo $DISPLAY | tr : _)"
else
    # Fallback: per-user (may run once per TTY)
    FASTFETCH_LOCKFILE="/tmp/.fastfetch-ran-$USER"
fi
if [ ! -f "$FASTFETCH_LOCKFILE" ]; then
    fastfetch
    touch "$FASTFETCH_LOCKFILE"
fi
export EDITOR=vim

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
shopt -s histappend

# Set history size
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size after each command
shopt -s checkwinsize

# Make `less` more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set chroot identifier for prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Enable color prompt if terminal supports it
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Function to switch profiles on demand
function sp() {
    local profile
    if [ -z "$1" ]; then
        if command -v fzf >/dev/null 2>&1; then
            profile=$(ls -1 ~/.env/ | grep -v '^\.' | fzf --prompt="Select profile: ")
            if [ -z "$profile" ]; then
                echo "No profile selected."
                return 1
            fi
        else
            echo "Available profiles in ~/.env/:"
            ls -1 ~/.env/ | grep -v '^\.' || echo "  (none found)"
            echo "Usage: switch_profile <profile_name>"
            echo "Tip: Install 'fzf' for interactive selection."
            return 1
        fi
    else
        profile="$1"
    fi
    if [ -f ~/.env/"$profile" ]; then
        source ~/.env/"$profile"
        export PROFILE_NAME="[$profile] "
        echo "Switched to profile: $profile"
    else
        echo "Profile '$profile' not found in ~/.env/"
        return 1
    fi
}

# Load default profile (mvpfoundry) at shell startup
if [ -f ~/.env/mvpfoundry ]; then
    source ~/.env/mvpfoundry
    export PROFILE_NAME="[mvpfoundry] "
else
    export PROFILE_NAME="[default] "
fi

# Function to parse Git branch
parse_git_branch() {
    git branch 2>/dev/null | grep '*' | sed 's/* /[/;s/$/]/'
}

# Set prompt with profile name, username, host, working directory, and Git branch
if [ "$color_prompt" = yes ]; then
    PS1='${PROFILE_NAME}${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \[\033[33m\]$(parse_git_branch) \[\033[00m\]\n\$ '
else
    PS1='${PROFILE_NAME}${debian_chroot:+($debian_chroot)}\u@\h:\w $(parse_git_branch) \n\$ '
fi
unset color_prompt force_color_prompt

# Set xterm title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${PROFILE_NAME}${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some useful ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alert alias for long-running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Load additional aliases if available
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion if not in POSIX mode
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Add local bin to PATH
export PATH=$HOME/.local/bin:$PATH
. ~/z/z.sh

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load Rust environment
. "$HOME/.cargo/env"

# Adjust touchpad settings
gsettings set org.gnome.desktop.peripherals.touchpad accel-profile 'flat'
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.27
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
