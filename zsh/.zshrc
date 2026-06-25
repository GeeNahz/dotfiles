# ===============
# Set up the prompt
# ===============

# autoload -Uz promptinit -- uncomment
# promptinit
# prompt adam1 -- uncomment

# ===============
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then -- uncomment
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" -- uncomment
# fi -- uncomment
# ===============

# ===============
# -- mac --
# ===============
# eval "$(/opt/homebrew/bin/brew shellenv)"
# export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# ===============
# Set the directory we want to store zinit and plugins
# ===============
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# ===============
# Download Zinit, if it's not there
# ===============
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone git@github.com:zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# ===============
# Source/Load zinit
# ===============
source "${ZINIT_HOME}/zinit.zsh"

# ===============
# Add in Powerlevel10k
# ===============
# zinit ice depth=1; zinit light romkatv/powerlevel10k -- uncomment



setopt histignorealldups sharehistory

# ===============
# Use emacs keybindings even if our EDITOR is set to vi
# ===============
bindkey -e

# ===============
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
# ===============
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# ===============
# Use modern completion system
# ===============
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# zsh autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# stow
alias stow='sudo STOW_DIR=/usr/local/stow /usr/bin/stow /opt/homebrew/bin/stow'


# -- linux --
# export PATH="$PATH:/opt/nvim-linux64/bin"

# ===============
# pnpm
# ===============
# -- mac --
# export PNPM_HOME="~/.local/share/pnpm"
# -- linux --
# export PNPM_HOME="/home/geenahz/.local/share/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# pnpm end


alias ls='ls --color=auto'
alias grep='grep --color=auto'

# ===============
# Set up fzf key bindings and fuzzy completion
# ===============
source <(fzf --zsh)

alias fzf="fzf --height 60% --layout reverse --border -m --bind 'enter:become(vim {})' --preview 'bat --color=always {}'"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# -- mac --
# export NVM_DIR="$HOME/.nvm"
#   [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# -- linux --
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# source /usr/share/nvm/init-nvm.sh

# -- mac --
# export PATH=~/.cache/rebar3/bin:$PATH
# -- linux --
# export PATH=/home/geenahz/.cache/rebar3/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
# [[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh -- do not uncomment

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh. -- uncomment
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh -- uncomment

# (( ! ${+functions[p10k]} )) || p10k finalize -- uncomment

# ===============
# starship zsh config setup
# ===============
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"


# ===============
# kitty
# ===============
export KITTY_CONFIG_DIRECTORY=~/.config/kitty

# ===============
# bun completions
[ -s "/Users/geenahz/.bun/_bun" ] && source "/Users/geenahz/.bun/_bun"
# ===============
# bun
# ===============
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ===============
# asdf
# ===============
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# initialise completions with ZSH's compinit
# autoload -Uz compinit && compinit

# ===============
# git aliases
# ===============
alias gstat="git status"
alias glogs="git log --oneline"
alias gitp="git push"
# git aliases via functions
function gadd() {
  git add $*
}
function gcommit() {
  git commit -m $1
}
function gdiff() {
  git diff $*
}
function gswitch() {
  git checkout $*
}
function grb() {
  git rebase $*
}
function grbi() {
  git rebase --interactive $*
}
function grst() {
  git restore $*
}
function grsts() {
  git restore --staged $*
}
function gpush() {
  git push $*
}
function gpull() {
  git pull $*
}
export PATH="$HOME/.local/bin:$PATH"

# Package management
alias yayu="sudo pacman -Syu && yay -Sua"

alias claude_jai_fe="claude --resume 51c4e8c2-e612-4a9a-9f78-8e3b3f57c11f"
alias claude_ms_be="claude --resume 45e8b66b-4545-4596-bc6b-f3534ee13ca7"
alias claude_ms_fe="claude --resume 3863303a-2b4a-414f-8955-2fa61ff7dfa5"
alias claude_budeshi_fe="claude --resume 51ffa98b-2dd0-430b-8cff-420ff35af546"
alias claude_budeshi_be="claude --resume 9040293d-19f4-41c4-9675-dd85c1f116dd"
alias claude_aforlink_fe="claude --resume bdd58cba-a108-43ba-909a-d10e56357448"
alias claude_aforlink_be="claude --resume db53eee6-a171-4a3a-b20a-27441810de11"
alias claude_iths_fe="claude --resume bd4427e5-2516-4a74-bd9c-21d4a16d6b30"
alias claude_devend="claude --resume fa69e2fa-c072-46ad-81e8-136758eee115"
alias claude_dotfiles="claude --resume ea2f5ce1-2721-4a2f-8252-878bb019fc03"
