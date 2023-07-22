#! /bin/zsh
function calculate_height() {
    local current_lines=$(tput lines)
    print $((current_lines * 2 / 3))
}

function fzf-history() {
    local height=$(calculate_height)
    local key=$1
    local sort=""
    case "$key" in
        $'up')
            sort="--tac"
            # 最新的在前
            ;;
        $'down')
            sort=""
            # 最旧的在前
            ;;
    esac
    local selected
    selected=$(fc -nl 0 | grep "^${LBUFFER}" | fzf --prompt "matches > " --layout=reverse --height=${height} ${sort})
    if [ -n "$selected" ]; then
        BUFFER=$selected
        zle end-of-line
    fi
    zle reset-prompt
}

function fzf-history-down() {
    fzf-history 'down'
}

function fzf-history-up() {
    fzf-history 'up'
}

zle -N fzf-history-down
zle -N fzf-history-up
bindkey '\e[B' fzf-history-down
bindkey '\e[A' fzf-history-up

