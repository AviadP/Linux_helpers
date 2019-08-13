# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export KUBECONFIG="/home/apolak/ocs_test1/auth/kubeconfig"
export PATH
#enable auto complation for kubectl
source <(kubectl completion bash)
source <(oc completion bash)

#Aliases
alias ap_venv="source ~/ocs-ci/ap_venv/bin/activate"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

prompt_git() {
    local s=""
    local branchName=""

    # check if the current directory is in a git repository
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; printf "%s" $?) == 0 ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]; then

            # ensure index is up to date
            git update-index --really-refresh  -q &>/dev/null

            # check for uncommitted changes in the index
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s="$s+";
            fi

            # check for unstaged changes
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s="$s!";
            fi

            # check for untracked files
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s="$s?";
            fi

            # check for stashed files
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s="$s$";
            fi

        fi

        # get the short symbolic ref
        # if HEAD isn't a symbolic ref, get the short SHA
        # otherwise, just give up
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
                      git rev-parse --short HEAD 2> /dev/null || \
                      printf "(unknown)")"

        [ -n "$s" ] && s=" [$s]"

        printf "%s" "$1$branchName$s"
    else
        return
    fi
}


tput sgr0 # reset colors

bold=$(tput bold)
reset=$(tput sgr0)

black=$(tput setaf 0)
blue=$(tput setaf 33)
cyan=$(tput setaf 37)
green=$(tput setaf 64)
orange=$(tput setaf 166)
purple=$(tput setaf 125)
red=$(tput setaf 124)
white=$(tput setaf 15)
yellow=$(tput setaf 136)

# build the prompt

# logged in as root
if [[ "$USER" == "root" ]]; then
    userStyle="\[$bold$red\]"
else
    userStyle="\[$orange\]"
fi

# connected via ssh
if [[ "$SSH_TTY" ]]; then
    hostStyle="\[$bold$red\]"
else
    hostStyle="\[$yellow\]"
fi

PS1="\[$cyan\][\t] "
PS1+="\[$orange\][\u@\[$yellow\]\h"]
PS1+="\[$green\]\W" # working directory
PS1+="\$(prompt_git \"$reset on $white\")" # git repository details
PS1+="\n"
PS1+="\[$reset$white\]\$ \[$reset\]" # $ (and reset color)


export PS1


