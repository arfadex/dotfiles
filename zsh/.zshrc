# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
# ZSH_THEME="robbyrussell"

# Enable plugins
#plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
plugins=(git zsh-autosuggestions)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias ls='eza --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'
alias c='clear'
# alias neofetch='catnap'
# alias cd='z'
alias f='fuck'
alias speed='speedtest-cli'
alias yay='yay --noconfirm'
alias wifi='nmtui'
alias ts='sudo -E timeshift-gtk'
alias z='zeditor'

# Tmux
# Attach to the last session
alias t='tmux attach || tmux new-session'
alias tmn='tmux new-session -s'
alias tma='tmux attach-session -t'
alias tml='tmux list-sessions'
alias tmd='tmux kill-session -t'

# Start Wireguard
alias wga='wg-quick up EOS'

# Stop Wireguard
alias wgd='wg-quick down EOS'

# Show status
alias wgs='wg show EOS'

# Pywal
cat ~/.cache/wal/sequences

# eval "$(thefuck --alias)"
# eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
