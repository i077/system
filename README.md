# NixOS Configuration

This repository stores my configuration files for all my machines running
[NixOS](https://nixos.org/).

## Structure

Files are split into two directories: `home` and `machines`.

- `home/` stores user- and application-specific configuration; essentially
  every "dotfile" that belongs in `~` goes in here. It houses
  configurations for [neovim](https://neovim.io), [fish](https://fishshell.com), etc, as
  well as custom package definitions in `home/packages/` that aren't in
  [nixpkgs](https://github.com/nix/nixpkgs) (yet). The home configuration
  is managed by [home-manager](https://github.com/rycee/home-manager).

- `machines/` stores machine-specific configuration, as well as
  system-wide service definitions that systemd uses. Every configuration
  file that belongs in `/etc` goes in here.
