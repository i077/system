# System configuration

This repository hosts system/user configuration for my macOS machines managed through [nix-darwin](https://github.com/LnL7/nix-darwin)
and their user environments managed through [home-manager](https://github.com/nix-community/home-manager).

## Structure

This repository is a [flake](https://www.tweag.io/blog/2020-05-25-flakes/).
Dependencies for this flake are specified in [`flake.nix`](./flake.nix) in the `inputs` set.
The output set is configured using [blueprint](https://github.com/numtide/blueprint).

- [`modules`](./modules) stores snippets of configuration for nix-darwin and home-manager.
- [`hosts`](./hosts) stores configuration for each machine managed in this repo.
  Home-manager config for each user is stored in the `users` subdirectory.
- [`bin`](./bin) is a collection of shell scripts I find useful.
  These are usually written for [fish](https://fishshell.com/).

## Maintenance

Common maintenance tasks, like updating the flake, switching configurations, and garbage-collecting
the Nix store are stored in a [Justfile](./Justfile) and run using
[just](https://github.com/casey/just).
