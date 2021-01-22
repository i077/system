#!/usr/bin/env fish

# ----- FORMATTING -----
set red (tput setaf 1)
set green (tput setaf 2)
set white (tput setaf 15)
set bold (tput bold)
set resf (tput sgr0)

function log_step
    echo $bold$white">> $argv[1]"$resf
end

function log_minor
    echo $white":: "$argv[1]$resf
end

function log_error
    echo $bold$red":: error: "$resf$red$argv[1]$resf
end

function log_ok
    echo $green":: "$argv[1]$resf
end

# ----- SETUP -----
set flakeRoot (dirname (status filename))
set flakeAttr (hostname)

if not set -q IN_NIX_SHELL
    log_step "\$IN_NIX_SHELL not set. Rerunning in a nix shell..."
    exec nix-shell $flakeRoot/shell.nix --run (status filename)" $argv"
end

# Format to 100 columns becauase this is the 21st century
set nixfmt_width 100

cd $flakeRoot

# ----- SUBCOMMANDS -----
function help
    echo -e $bold"Usage:"$resf" ./do [flags] [verb] [options]\n"
    echo $bold"Flags:"$resf
    echo "    -f, --format        Format .nix files with nixfmt & re-commit them when running checks"
    echo "    -C, --no-check      Don't run checks when building configuration"
    echo
    echo $bold"Verbs:"$resf
    echo "        help            Print this help message"
    echo "        clean           Clean up nix build outputs"
    echo "        check           Run checks on this repository"
    echo "     s, switch          Build, activate, and add boot entry for the current configuration"
    echo "     b, boot            Build and add boot entry for the current configuration"
    echo "     t, test            Build and activate the current configuration"
    echo "        build           Build the current configuration"
    echo "        dry             Show what would be built under the current configuration"
    echo "        update          Update flake inputs"
    echo "    sh, shell           Spawn a devShell (use -c to specify a command)"
    echo "        repl            Start nix repl with flake"
    echo "        git             Execute a git command in this repository"
    echo "        gc              Delete unreachable store paths"
    echo "        GC [D]          Delete generations older than D days (60 by default)"
    echo "        install N       Install N's configuration to /mnt"
    echo "    up, upgrade         Run update and switch"
    echo "        ub              Run update and boot"
    echo "        ut              Run update and test"
end

function clean
    log_step "Cleaning up build outputs..."
    [ -L result ] && rm -f result
end

function check
    log_step "Running checks..."

    # Check that nix files are formatted properly (or format if -f is passed)
    if test -z $_flag_format
        set format_logmsg "Checking formatting with nixfmt..."
    else
        set format_logmsg "Formatting with nixfmt..."
    end
    log_minor $format_logmsg
    set -l unformatted_files \
        (find . -name '*.nix' \
            # Exclude files not handled well by nixfmt
            ! -path ./modules/editors/neovim/default.nix \
            -exec nixfmt -c -w $nixfmt_width {} + &| \
            grep "not formatted" | sed -e "s/\(.*\): not formatted/\1/")
    # If there are any unformatted files...
    if test (count $unformatted_files) -gt 0
        # ...and -f is not set, just error out
        if test -z $_flag_format
            log_error "The files below aren't formatted properly. Run nixfmt on them or pass '--format'."
            for f in $unformatted_files; echo " $f"; end
            exit 1
        # Otherwise, run nixfmt, then amend the last commit
        else
            nixfmt -w $nixfmt_width $unformatted_files
            git add $unformatted_files
            git commit --amend --no-edit
        end
    end

    # Check that working tree is clean
    log_minor "Checking for uncommitted changes..."
    set -l unclean_files (git ls-files -m -o -d --exclude-standard)
    if test -n "$unclean_files"
        log_error "Git working tree is unclean. Commit or stash changes to these files:"
        for f in (git ls-files --exclude-standard -o); echo " $f"; end
        git diff --name-only | sed -e "s/\(.*\)/ \1/"
        exit 1
    end

    log_ok "Everything looks good."
end

function switch_
    test -z $_flag_no_check && check
    log_step "Building, activating, and adding boot entry for configuration..."
    sudo nixos-rebuild switch
end

function test_
    test -z $_flag_no_check && check
    log_step "Building and activating configuration..."
    sudo nixos-rebuild --fast test
end

function boot
    test -z $_flag_no_check && check
    log_step "Building and adding boot entry for configuration..."
    sudo nixos-rebuild boot
end

function build
    test -z $_flag_no_check && check
    log_step "Building configuration..."
    nixos-rebuild build --flake "$flakeRoot#$flakeAttr"
end

function dry
    test -z $_flag_no_check && check
    nixos-rebuild dry-build
end

function update
    log_step "Updating flake inputs..."
    set lastCommit (git log --format=%h -1)
    nix flake update --recreate-lock-file --commit-lock-file
    if test lastCommit != (git log --format=%h -1)
        # Print which inputs were updated
        log_ok "Updated inputs:"
        git log --format=%B -1 | grep "Updated" | \
            sed "s/\* Updated '\(.*\)': '.*\([0-9a-f]\{7\}\)[0-9a-f]\{33\}' -> '.*\([0-9a-f]\{7\}\)[0-9a-f]\{33\}'/     \1: \2 -> \3/"
    else
        # No flake inputs were changed
        log_ok "No flake inputs were updated."
    end
end

function shell
    nix develop $flakeRoot $argv
end

function repl
    nix repl https://github.com/edolstra/flake-compat/archive/master.tar.gz --arg src $flakeRoot
end

function git
    command git -C $flakeRoot $argv
end

function upgrade
    update
    switch_
end

function gc
    log_step "Removing unreachable store paths..."
    nix-collect-garbage
end

function GC
    if test -z $argv[1]
        set period 60
    else
        set period $argv[1]
    end
    log_step "Removing generations older than $period days..."
    sudo nix-collect-garbage --delete-older-than {$period}d
end

function install
    # Validate arguments
    if test -z $argv[1]
        log_error "No device name given."
        exit 121
    end

    test -z $_flag_no_check && check

    set prefix /mnt
    # Check for device config
    log_step "Bootstrapping configuration for this device..."
    if not mountpoint -q $prefix
        log_error "Nothing mounted at /mnt."
        exit 1
    else if not test -f $flakeRoot/hosts/$argv[1]/default.nix
        log_error "No device configuration found for $argv[1]."
    end

    log_minor "Generating hardware configuration..."
    nixos-generate-config --show-hardware-config > $flakeRoot/hosts/$argv[1]/hardware-configuration.nix
    # Commit since tree needs to be clean
    git add hosts/$argv[1]/hardware-configuration.nix
    git commit -m "Add device config for $argv[1]"

    # Build and install config
    log_step "Building config and installing to to $prefix..."
    sudo nixos-install --root $prefix --flake $flakeRoot#$argv[1]
    log_ok "Done installing. You can reboot into the installed system."
end

# Parse flags and make them global
argparse -s "f/format" "C/no-check" -- $argv
set -g _flag_format $_flag_format
set -g _flag_no_check $_flag_no_check

# Parse rest of arguments
switch $argv[1]
    case help clean check boot build dry update upgrade gc repl
        $argv[1]
    # Case for reserved keywords
    case "switch" "test"
        $argv[1]_
    # Functions that take arguments
    case shell git GC install
        $argv[1] $argv[2..-1]
    # Abbreviations
    case s
        switch_
    case b
        boot
    case t
        test_
    case sh
        shell $argv[2..-1]
    case up
        upgrade
    case ub
        update
        boot
    case ut
        update
        test_
    case ''
        help
        exit 121
    case '*'
        log_error "Unknown verb: $argv[1]"
        exit 121
end

# vim: set ft=fish:
