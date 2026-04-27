# bash completion for sshvault
# Installed to /usr/share/bash-completion/completions/sshvault
#
# Completes long flags and option arguments. Hostname completion (the
# bare-positional case) shells out to `sshvault --list-hosts` which prints
# one host name per line. The fallback path on stale state is a no-op,
# so a slow or missing instance never blocks the terminal.

_sshvault() {
    local cur prev words cword
    _init_completion || return

    local opts="
        --help -h
        --version -v
        --minimized
        --quit
        --import-config
        --import-keys
        --export-vault
    "

    case "$prev" in
        --import-config)
            # OpenSSH config file
            _filedir
            return 0
            ;;
        --import-keys)
            _filedir -d
            return 0
            ;;
        --export-vault)
            _filedir
            return 0
            ;;
    esac

    if [[ "$cur" == -* ]]; then
        # shellcheck disable=SC2207
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return 0
    fi

    # Bare positional → host names from the running vault. Catch all errors
    # so we never spew warnings in the user's shell.
    local hosts
    hosts="$(sshvault --list-hosts 2>/dev/null)"
    if [ -n "$hosts" ]; then
        # shellcheck disable=SC2207
        COMPREPLY=( $(compgen -W "$hosts" -- "$cur") )
    fi
    return 0
}

complete -F _sshvault sshvault
