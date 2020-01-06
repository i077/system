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

- `secrets/` stores strings that are not publicly accessible (API tokens, etc).
  Everything in this directory is encrypted with GPG via [git-crypt](https://github.com/AGWA/git-crypt).

## Usage

To bootstrap a NixOS system with an existing configuration (e.g. `spectre`, my current laptop),
from the installer, mount the target filesystem (assumed here to be on `/mnt`).
Clone this repository to `/etc/nixos` on the target filesystem
(alternatively, clone it elsewhere on the filesystem and symlink `/etc/nixos` to it),
then add a top-level `configuration.nix` with:

```nix
{
  imports = [ ./machines/<name> ];
}
```

Replace `<name>` with the name of the configuration, a subdirectory of `machines/` (e.g. `spectre`).

To decrypt secrets, import the PGP private key and decrypt with `git-crypt`:

```sh
$ git-crypt unlock
```

```sh
$ nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
$ nix-channel --add https://nixos.org/channels/nixos-unstable unstable
```

The hardware configuration may also need to be regenerated to reflect UUID changes, etc.
Generate it, then move it to the appropriate directory.

```sh
$ nixos-generate-config --root /mnt  # Creates /etc/nixos/hardware-configuration.nix
$ mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/machines/<name>/
```

Finally, run `nixos-install`.
