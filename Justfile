# Build & activate this host's profile
switch: check fmt
    darwin-rebuild --flake . switch

# Deploy server profiles
deploy host='': check fmt
    deploy .#{{ host }}

# Format files, and ask to amend last commit if changes are present
fmt:
    #!/usr/bin/env fish
    source bin/_lib.fish
    if not treefmt -q --fail-on-change
        git update-index
        set -l reformatted_files (git ls-files -m -o -d --exclude-standard)
        if test (count $reformatted_files) -gt 0
            log_warn "The files below were re-formatted:"
            for f in $reformatted_files
                echo "- $f"
            end
            if ask_yesno "Amend the last commit with these changes?"
                git add $reformatted_files
                git commit --amend --no-edit
            else
                exit 1
            end
        end
    end

# Start a REPL with flake outputs
repl:
    @nix repl --expr 'let \
        flake = builtins.getFlake "'$(pwd)'"; \
        hostname = "'$(hostname)'"; \
        pkgs = flake.inputs.nixpkgs.legacyPackages.${builtins.currentSystem}; in \
        { inherit flake pkgs; inherit (pkgs) lib; configs = flake.darwinConfigurations // flake.nixosConfigurations; }'

# Build this host's profile
build:
    darwin-rebuild --flake . build

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

# Garbage-collect the Nix store
gc age='60':
    sudo nix-collect-garbage --delete-older-than {{ age }}d
    nix-collect-garbage
