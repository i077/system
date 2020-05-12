# NixOS Configuration

This repository stores my configuration files for all my machines running
[NixOS](https://nixos.org/).

## Structure

This repository is a [flake](https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md).
Dependencies of this configuration are specified in `flake.nix` in the `inputs` set.

- [`modules/`](./modules) stores all the NixOS modules used to specify the
  system configuration. These include options for system-wide
  configuration such as [printing](./modules/printing.nix),
  program-specific config such as [fish](./modules/env/fish.nix), and
  services such as [scheduled backups](./modules/backup.nix). Every
  "dotfile" or config file that belongs in `~` or `/etc` goes in here.

- [`hosts/`](./hosts) specifies device-specific configuration for each of
  my devices running NixOS, (e.g. [spectre](./hosts/spectre), my current
  laptop). Attributes such as CPU core count and HiDPI are stored here and
  used in other modules' logic (e.g. scale the font size up if the device
  has a HiDPI screen). Additionally, the results of NixOS's hardware
  scan for each device go here as well.

- [`packages/`](./packages) stores Nix expressions for packages that aren't in
[nixpkgs](https://github.com/NixOS/nixpkgs) (yet).
[`packages/default.nix`](./packages/default.nix) is a module that adds an
overlay containing the packages in this directory.

- `private.nix`, as the name implies, holds private info, and is encrypted
with [git-crypt](https://github.com/AGWA/git-crypt). You can view the
structure of this file in the [module](./modules/private.nix) where it is
declared.

## Usage

To bootstrap a NixOS system with an existing configuration (e.g. `spectre`, my current laptop),
from the installer, mount the target filesystem (assumed here to be on `/mnt`).
Clone this repository to `/etc/nixos` on the target filesystem
(alternatively, clone it elsewhere on the filesystem and symlink
`/etc/nixos` to it).

Create `private.nix`, or decrypt it with `git crypt unlock` after
importing the PGP private key.

The hardware configuration may need to be regenerated to reflect partition
UUID changes, etc. Generate it, then move it to the appropriate directory.

```sh
$ nixos-generate-config --root /mnt  # Creates /etc/nixos/hardware-configuration.nix
$ mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/<name>/
```
For a new system, create a new directory under `hosts/` and add
`default.nix` (manually, see the other hosts' configs) and
`hardware-configuration.nix` (through `nixos-generate-config`).

Finally, install the configuration. Since flake support for
`nixos-install` is
a [work-in-progress](https://github.com/NixOS/nixpkgs/pull/68897), the
system's closure needs to be built first, then installed.

```sh
$ nixos-rebuild build --flake /mnt/etc/nixos --config i077-<name> # Creates ./result
$ nixos-install --system result
```
