export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

alias ipinternal="curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' "
alias ipexternal="wget -qO- http://ipecho.net/plain ; echo"


# Current terminal directory path length
alias trimpath="PROMPT_DIRTRIM=1"
