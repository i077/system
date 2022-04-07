# System configuration

This repository hosts system/user configuration for my servers running [NixOS](https://nixos.org) and my macOS machines
managed through [nix-darwin](https://github.com/LnL7/nix-darwin), as well as user environments managed through
[home-manager](https://github.com/nix-community/home-manager).

## Structure

This repository is a [flake](https://www.tweag.io/blog/2020-05-25-flakes/).
Dependencies for this flake are specified in [`flake.nix`](./flake.nix) in the `inputs` set.

- [`modules`](./modules) stores snippets of configuration for NixOS, nix-darwin, and home-manager.
- [`hosts`](./hosts) stores configuration for each machine managed in this repo.
  User environment config is stored in a `home.nix` file or `home` directory for each host (if at all).
- [`bin`](./bin) is a collection of shell scripts I find useful. These are usually written for [fish](https://fishshell.com/).

## Maintenance

[`sysdo`](./bin/sysdo) is a fish script I wrote to help manage common tasks like updating
this flake and rebuilding the system configuration (`sysdo up`) or removing
generations more than a month old (`sysdo GC 30`).

`$ sysdo help`

```
Usage: sysdo [flags] [verb] [options]

Flags:
    -C, --no-check      Don't run checks when building configuration
    -r, --review        Review changes in configuration before activating
    -k, --keep-result   Keep nix build output symlinks

Verbs:
        help            Print this help message
        clean           Clean up nix build outputs
        check           Run checks on this repository
     s, switch          Build, activate, and add boot entry for the current configuration
     b, boot            Build and add boot entry for the current configuration
     t, test            Build and activate the current configuration
        build           Build the current configuration
        update          Update flake inputs
    sh, shell           Spawn a devShell (use -c to specify a command)
        repl            Start nix repl with flake
        git             Execute a git command in this repository
        gc              Delete unreachable store paths
        GC [D]          Delete generations older than D days (60 by default)
    up, upgrade         Run update and switch
        ub              Run update and boot
        ut              Run update and test
```
