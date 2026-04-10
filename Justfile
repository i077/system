# Build & activate this host's profile
switch: check fast-switch

# Switch without running checks/formatting, for rapid iteration
fast-switch:
    sudo darwin-rebuild --flake .#$(just get-name) switch

# Diff this host's closure in the flake against its current one
diff:
    nix build ".#darwinConfigurations.$(just get-name).system" -o ./new-system
    nvd --color always diff /run/current-system ./new-system | less -FR
    rm ./new-system

# Start a REPL with flake outputs
repl:
    @nix repl --expr 'let \
        flake = builtins.getFlake "'$(pwd)'"; \
        pkgs = flake.inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; in \
        { inherit flake pkgs; inherit (pkgs) lib; configs = flake.darwinConfigurations // flake.nixosConfigurations; }'

# Build this host's profile
build:
    darwin-rebuild --flake .#$(just get-name) build

# Check for a clean working tree
check:
    #!/usr/bin/env fish
    source bin/_lib.fish
    set -l unclean_files (git ls-files -m -o -d --exclude-standard)
    if test -n "$unclean_files"
        log_error "Git working tree is unclean. Commit or stash changes to these files:"
        for f in $unclean_files
            echo "- $f"
        end
        exit 1
    end

# Merge the latest flake update commit
up: check
    #!/usr/bin/env fish
    source bin/_lib.fish
    ./bin/flakeup-logs
    if ask_yesno "Merge the latest update commit?"
        git fetch
        if ! git merge-base --is-ancestor master origin/update_flake_lock_action
            log_warn "Cannot merge using fast-forward."
            if ask_yesno "Cherry-pick commit instead?"
                git cherry-pick origin/update_flake_lock_action
            end
        end
    end

# Garbage-collect the Nix store
gc age='60':
    sudo nix-collect-garbage --delete-older-than {{ age }}d
    nix-collect-garbage

# Get name of config to apply, overriden with .hostname file
[private]
@get-name:
    [[ -f .hostname ]] && cat .hostname || hostname | tr 'A-Z' 'a-z'
