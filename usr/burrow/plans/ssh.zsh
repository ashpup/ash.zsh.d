if [ -v SSH_AUTH_SOCK ]; then
  # do nothing
elif [ -v SSH_HOST_SOCK ]; then
  export SSH_AUTH_SOCK="$SSH_HOST_SOCK"
else
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi
