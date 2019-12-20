# NixOS Configuration

This repository stores my configuration files for all my machines running
[NixOS](https://nixos.org/).

## Structure

Files are split into several directories.

- `home/` stores user- and application-specific configuration; essentially
  every "dotfile" that belongs in `~` goes in here. It houses
  configurations for [neovim](https://neovim.io), [fish](https://fishshell.com), etc. The home configuration
  is managed by [home-manager](https://github.com/rycee/home-manager).

- `machines/` stores machine-specific configuration, as well as
  system-wide service definitions that systemd uses. Every configuration
  file that belongs in `/etc` goes in here.

- `packages/` stores Nix expressions for packages that aren't in [nixpkgs](https://github.com/NixOS/nixpkgs)
  (yet).

- Some code may contain references to files in `secrets/` which is a directory not tracked here for obvious reasons.

## Usage

To bootstrap a NixOS system with an existing configuration (e.g. `spectre`, my current laptop),
clone this repository to `/etc/nixos` on the root filesystem, then add a `configuration.nix` with:
```nix
{
  imports = [ ./machines/<name> ];
}
```
where `<name>` is the name of the configuration (e.g. `spectre`).
Then run `nixos-rebuild`.
