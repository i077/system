# ----- FORMATTING -----
set red (tput setaf 1)
set green (tput setaf 2)
set white (tput setaf 15)
set purple (tput setaf 5)
set yellow (tput setaf 3)
set bold (tput bold)
set resf (tput sgr0)

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

function ask_yesno
    # Workaround to remove the mode indicator
    function fish_mode_prompt; end

    read -n 1 -P $purple"?? "$argv[1]" (y/N) "$resf reply
    if test $reply = y
        return 0
    end
    return 1
end
