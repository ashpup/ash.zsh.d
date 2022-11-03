export FZF_DEFAULT_OPTS='
  --layout=reverse
  --multi
  --preview "echo {}"
  --preview-window down:3:hidden:wrap
  --bind ?:toggle-preview
  --bind ctrl-d:half-page-down
  --bind=ctrl-e:half-page-up
  --color=fg:#d0d0d0,bg:-1,hl:#ec7591
  --color=fg+:#d0d0d0,bg+:#242424,hl+:#e6486d
  --color=info:#ec9575,prompt:#d7005f,pointer:#d075ec
  --color=marker:#75ec95,spinner:#9575ec,header:#75cdec
'
