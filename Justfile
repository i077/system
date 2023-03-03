default:
    @just --list

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

repl:
    @nix repl --file repl.nix --argstr hostname $(hostname)

update:
    nix flake update --commit-lock-file

build:
    darwin-rebuild --flake . build

switch: check fmt
    darwin-rebuild --flake . switch

s: switch

boot: check fmt
    darwin-rebuild --flake . boot

up: update switch

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

gc age='60':
    sudo nix-collect-garbage --delete-older-than {{ age }}d
    nix-collect-garbage
