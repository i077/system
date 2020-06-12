#!/usr/bin/env nix-shell
#!nix-shell -p fish gnupg git git-crypt utillinux -i fish

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
    echo $bold$red":: error: "$resf$argv[1]
end

function log_ok
    echo $green":: "$argv[1]$resf
end

# ----- SETUP -----
set flakeRoot /etc/nixos
set flakeAttr (hostname)

# ----- SUBCOMMANDS -----
function help
    echo -e "Usage: ./do [verb] [options]\n"
    echo "Possible verbs:"
    echo "        help            Print this help message"
    echo "        clean           Clean up nix build outputs"
    echo "        switch,s        Build, activate, and add boot entry for the current configuration"
    echo "        boot,b          Build and add boot entry for the current configuration"
    echo "        test,t          Build and activate the current configuration"
    echo "        build           Build the current configuration"
    echo "        dry             Show what would be built under the current configuration"
    echo "        update          Update flake inputs"
    echo "        gc              Delete unreachable store paths"
    echo "        GC [D]          Delete generations older than D days (60 by default)"
    echo "        install N       Install configuration to /mnt with hostname i077-N"
    echo "        upgrade,up      Run update and switch"
    echo "        ub              Run update and boot"
    echo "        ut              Run update and test"
end

function clean
    log_step "Cleaning up build outputs..."
    [ -L result ] && rm -f result
end

function check
    log_step "Running checks..."
    log_minor "Checking for uncommitted changes..."
    set unclean_files (git ls-files -m -o -d --exclude-standard)
    if test -n "$unclean_files"
        log_error "Git working tree is unclean. Commit or stash changes to these files:"
        for f in (git ls-files --exclude-standard -o); echo " $f"; end
        git diff --stat
        exit 1
    end
    log_ok "Everything looks good."
end

function switch_
    check
    log_step "Building, activating, and adding boot entry for configuration..."
    sudo nixos-rebuild switch
end

function test_
    check
    log_step "Building and activating configuration..."
    sudo nixos-rebuild test
end

function boot
    check
    log_step "Building and adding boot entry for configuration..."
    sudo nixos-rebuild boot
end

function build
    check
    log_step "Building configuration..."
    nixos-rebuild build --flake "$prefix$flakeRoot#$flakeAttr"
end

function dry
    check
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
            sed "s/\* Updated '\(.*\)': '.*\/\([0-9a-f]\{7\}\)[0-9a-f]\{33\}' -> '.*\/\([0-9a-f]\{7\}\)[0-9a-f]\{33\}'/     \1: \2 -> \3/"
    else
        # No flake inputs were changed
        log_ok "No flake inputs were updated."
    end
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
    if not set -q argv
        log_error "No device name given."
        exit 121
    end

    set prefix /mnt
    log_step "Bootstrapping configuration for this device..."
    if not mountpoint -q $prefix
        log_error "Nothing mounted at /mnt."
        exit 1
    else if not test -f $prefix$flakeRoot/hosts/$argv[1]/default.nix
        log_error "No device configuration found for $argv[1]."
    end

    log_minor "Unlocking private module..."
    git-crypt unlock
    log_minor "Generating hardware configuration..."
    nixos-generate-config --show-hardware-config > $prefix$flakeRoot/hosts/$argv[1]/hardware-configuration.nix
    # Commit since tree needs to be clean
    git commit -m "temp: Add device config for $argv[1]"

    # Build and install config
    build
    log_step "Installing system closure to $prefix..."
    sudo nixos-install --root $prefix --system ./result
    log_ok "Done installing. You can reboot into the installed system."
end

# Parse arguments
switch $argv[1]
    case help clean check boot build dry update upgrade gc
        $argv[1]
    # Case for reserved keywords
    case "switch" "test"
        $argv[1]_
    # Functions that take arguments
    case GC install
        $argv[1] $argv[2..-1]
    # Abbreviations
    case s
        switch_
    case b
        boot
    case t
        test_
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
