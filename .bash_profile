IS_ZSH=
if [ -z "$ZSH" ]; then
  IS_ZSH=1
fi

export CONFIG_DIR="/tmp/.jonradchenko_config"
if [ -d "$HOME/.jonradchenko_config" ]; then
  export CONFIG_DIR="$HOME/.jonradchenko_config"
fi

### General
alias ls="ls -last --color=auto"

### Kubernetes
if [ -x "$(command -v kubectl)" ]; then
  alias k="kubectl"

  kb () {
    POD=$1
    shift

    PREVIOUSPREPROMPT=$PREPROMPT
    if [ -z "$PREPROMPT" ]; then
      PREPROMPT="local > "
    else
      PREPROMPT="$PREPROMPT$HOSTNAME > "
    fi

    eval "$k exec $POD $@ -- rm -rf /tmp/.jonradchenko_config" && \
    eval "$k cp $CONFIG_DIR $POD:/tmp/.jonradchenko_config $@" && \
    eval "$k exec -it $POD $@ -- /usr/bin/env PREPROMPT=\"$PREPROMPT\" /bin/bash --init-file /tmp/.jonradchenko_config/.bash_profile"

    PREPROMPT="$PREVIOUSPREPROMPT"
  }

  function buildk {
    k="kubectl"
    kprompt=""
    if [ -n "$kcontext" ]; then
      k="$k --context=$kcontext"
      kprompt=$kcontext
    fi
    if [ -n "$knamespace" ]; then
      k="$k --namespace=$knamespace"
      kprompt="$kcontext.$knamespace"
    fi

    export kprompt

    alias k="$k"
  }

  function kctx {
    export kcontext=$1
    buildk
  }

  function kns {
    export knamespace=$1
    buildk
  }

  if [ $ZSH ]; then
    source <(kubectl completion zsh)
  
    complete -F __kubectl_get_resource_namespace kns
    complete -F __kubectl_config_get_contexts kctx
  else
    source <(kubectl completion bash)
  fi

fi

### SSH
alias su="sudo PREPROMPT=\"$PREPROMPT\" -s bash --init-file $CONFIG_DIR/.bash_profile"

function s() {
  HOST=$1
  shift
  ARGS=$@

  scp -r ~/.jonradchenko_config $HOST:/tmp/ $ARGS && ssh -t $HOST PREPROMPT="local\\ \\>\\ " /bin/bash --init-file /tmp/.jonradchenko_config/.bash_profile
}

### VIM
# export VIMINIT="source $CONFIG_DIR/.vimrc"

### TERM
export PS1="\[\e[35m\]$PREPROMPT\[\e[m\]\[\e[36m\]\u\[\e[m\]@\[\e[33m\]\h\[\e[m\]:\[\e[32m\]\W\[\e[m\] \\$ "

