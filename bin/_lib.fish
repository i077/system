# Some helper functions used throughout the other fish scripts.

# ----- FORMATTING -----
set red (tput setaf 1)
set green (tput setaf 2)
set white (tput setaf 15)
set purple (tput setaf 5)
set yellow (tput setaf 3)
set bold (tput bold)
set resf (tput sgr0)

# ----- LOGGING -----
function log_step
    echo $bold$white">> $argv[1]"$resf 1>&2
end

function log_minor
    echo $white":: "$argv[1]$resf 1>&2
end

function log_error
    echo $bold$red":: error: "$resf$red$argv[1]$resf 1>&2
end

function log_warn
    echo $bold$yellow":: warning: "$resf$yellow$argv[1]$resf 1>&2
end

function log_ok
    echo $green":: "$argv[1]$resf 1>&2
end

# ----- PROMPTING -----
# Ask a yes/no question, with no being the default answer (unless --yes is passed)
# Typical usage:
#     if ask_yesno "Do something?"
#         action_if_yes
#     else
#         action_if_no
#     end
function ask_yesno
    argparse y/yes -- $argv
    # Workaround to remove the mode indicator
    function fish_mode_prompt
    end

    if set -q _flag_yes
        set yesno '(Y/n)'
    else
        set yesno '(y/N)'
    end

    read -n 1 -P $purple"?? "$argv[1]" "$yesno" "$resf reply
    if contains $reply y Y
        return 0
    else if contains $reply n N
        return 1
    else if set -q _flag_yes
        return 0
    end
    return 1
end

function ask_silent
    # Workaround to remove the mode indicator
    function fish_mode_prompt
    end

    read --silent -P $purple"?? "$argv[1]" "$resf
end

# ----- UTILITY -----
# Check if a list of programs is in $PATH
function check_progs
    for p in $argv
        if not command -q $p
            log_error "Command '$p' not found in PATH."
            exit 127
        end
    end
end

# Utils for dictionaries stored as universal variables
function dict_init --argument-names dict
    if not set -Uq $dict
        set -U $dict '{}'
    end
end

function dict_set --argument-names dict key value
    dict_init $dict
    set -U $dict (echo $$dict | jq '. * {"'$key'": "'$value'"}')
end

function dict_get --argument-names dict key
    dict_init $dict
    echo $$dict | jq -r '.["'$key'"]'
end

function dict_query --argument-names dict key
    dict_init $dict
    echo $$dict | jq -e 'has("'$key'")' > /dev/null
end

function dict_list_keys --argument-names dict
    dict_init $dict
    echo $$dict | jq -r '. | keys[]'
end

function dict_clear --argument-names dict key
    set -Ue $dict
end
