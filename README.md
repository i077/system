# NixOS Configuration

This repository stores my configuration files for all my machines running
[NixOS](https://nixos.org/).

## Structure

This repository is a [flake](https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md).
Dependencies of this configuration are specified in `flake.nix` in the `inputs` set.

- [`modules/`](./modules) stores all the NixOS and
  [home-manager](https://github.com/rycee-home-manager) modules used to specify the
  system configuration. These include options for system-wide
  configuration such as [printing](./modules/printing.nix),
  program-specific config such as [fish](./modules/env/fish.nix), and
  services such as [scheduled backups](./modules/backup.nix). Every
  "dotfile" or config file that belongs in `~` or `/etc` goes in here.

- [`hosts/`](./hosts) specifies device-specific configuration for each of
  my devices running NixOS, (e.g. [giratina](./hosts/giratina), my current
  laptop). Attributes such as CPU core count and HiDPI are stored here and
  used in other modules' logic (e.g. scale the font size up if the device
  has a HiDPI screen). The results of NixOS's hardware
  scan for each device go here as well.

- [`packages/`](./packages) stores Nix expressions for packages that aren't in
[nixpkgs](https://github.com/NixOS/nixpkgs) (yet).
[`packages/default.nix`](./packages/default.nix) is a module that adds an
overlay containing the packages in this directory.

- `private.nix`, as the name implies, holds private info, and is encrypted
with [git-crypt](https://github.com/AGWA/git-crypt). You can view the
structure of this file in the [module](./modules/private.nix) where it is
declared.

- [`do`](./do) is a fish script I wrote to help manage common tasks like
  updating this flake and rebuilding the system configuration (`./do up`) or
  removing generations more than a month old (`./do GC 30`).

## Installing

[Partition and format](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning),
then mount the target filesystem to `/mnt`, import the GPG key, and clone this repo:

```sh
mkdir -p /mnt/etc/nixos
nix-shell -p gnupg --run "gpg --import /path/to/key"
git clone https://github.com/i077/system /mnt/etc/nixos
```

For a new device, create a new directory under `hosts/` and add
`default.nix` (see the other hosts' configs for structure).

Finally, install the configuration,
passing the name of the device:

```sh
# In /mnt/etc/nixos
./do install devicename
```
