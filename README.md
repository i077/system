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

Common maintenance tasks, like updating the flake, switching configurations, and garbage-collecting
the Nix store are stored in a [Justfile](./Justfile) and run using
[just](https://github.com/casey/just).
