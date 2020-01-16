# ZAsh ZSH framwork
# noriah <vix@noriah.dev>
#
# See LICENSE file

typeset -g ZASH_PLUGINS=()

function zash_has_plugin() {
  local item
  item="$1"
  if [[ ${ZASH_PLUGINS[(i)$item]} -le ${#ZASH_PLUGINS} ]]
  then
    return 0
  fi
  return 1
}

function zash() {
  function _zash_base() {
    [[ -f "${ZSH_BASE_DIR}/$1.zsh" ]] && source "${ZSH_BASE_DIR}/$1.zsh"
  }

  function _zash_config() {
    [[ -f "${ZSH_CONF_DIR}/$1.zsh" ]] && source "${ZSH_CONF_DIR}/$1.zsh"
  }

  function _zash_library() {
    if [[ -d "${ZSH_LIB_DIR}/$1" ]] && [[ -f "${ZSH_LIB_DIR}/$1/$1.lib.zsh" ]]; then
      _zash_config "$1"

      source "${ZSH_LIB_DIR}/$1/$1.lib.zsh"
    fi
  }

  function _zash_plugin() {
    local pdir
    local item
    item="$1"
    pdir="${ZSH_PLUGIN_DIR}/$item"
    if [[ -d "$pdir" ]] && [[ -f "$pdir/$item.plugin.zsh" ]]; then
      _zash_config "$1"

      unset -m "ZASH_PLUGIN_FAIL"

      source "$pdir/$item.plugin.zsh"

      if (( ${+ZASH_PLUGIN_FAIL} )); then echo "Zash: Failed to load '$item' plugin"; fi

      fpath=($pdir $fpath)
      ZASH_PLUGINS+=("$item")
    fi
  }


  function _zash_plugins() {
    while read i
    do
      [[ "$i" != "#*" ]] && _zash_plugin "$i"
    done < "$1"
  }

  function _zash_do_autoload() {
    autoload -Uz add-zsh-hook compinit
  }

  function _zash_do_compinit() {
    compinit -C -d "${ZSH_COMP_FILE}"
  }

  function _zash_do_clean() {
    rm "${ZSH_COMP_FILE}"
  }

  function _zash_do_hook() {
    function _zash_hook_compinit () {
      _zash_do_compinit
      add-zsh-hook -D precmd _zash_hook_compinit
    }

    add-zsh-hook precmd _zash_hook_compinit
  }

  function _zash_do() {
    local action

    action="$1"

    case "$action" in
      "autoload")
        _zash_do_autoload
        ;;

      "clean")
        _zash_do_clean
        ;;

      "compinit")
        _zash_do_compinit
        ;;

      "hook")
        _zash_do_hook
        ;;

      *)
        return
        ;;
    esac
  }

  local action
  local item

  action="$1"
  item="$2"
  extra="${@:3}"

  case "$action" in
    "base")
      _zash_base "$item"
      ;;

    "library")
      _zash_library "$item"
      ;;

    "plugin")
      _zash_plugin "$item"
      ;;

    "plugins")
      _zash_plugins "$item"
      ;;

    "do")
      _zash_do "$item"
      ;;

    *)
      return
      ;;
  esac
}
