# NixOS Configuration

This repository stores my configuration files for all my machines running
[NixOS](https://nixos.org/).

## Structure

This repository is a [flake](https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md).
Dependencies of this configuration are specified in `flake.nix` in the `inputs` set.

- [`modules/`](./modules) stores NixOS modules that abstract existing NixOS and
  [home-manager](https://github.com/rycee-home-manager) options.
  This includes modules for system-wide configuration such as for the [GPU](./modules/hardware/video.nix),
  services such as [scheduled backups](./modules/services/backup.nix),
  and program-specific config such as the [fish shell](./modules/shell/fish.nix).

  Each module is exposed as a flake output under `nixosModules`.

- [`hm-modules`](./hm-modules) stores home-manager modules that I use in my configuration,
  like one for [rotating the wallpaper](./hm-modules/gnome-background.nix) in GNOME.
  They could potentially be merged upstream into home-manager.

  Each of these modules is exposed as a flake output under `homeManagerModules`.

- Each directory in [`hosts/`](./hosts) stores device-specific configuration
  such as for [giratina](./hosts/giratina), my current laptop.
  Essentially each host's config enables specific modules from `modules/`,
  which in turn changes specific NixOS options.
  `hosts/profiles/` is an exception, and stores baseline configuration for types of machines
  (e.g. personal machines or servers).

  Each host's configuration is exposed as a flake output under `nixosConfigurations`.

- [`lib/`](./lib) defines a bunch of helper functions I used throughout this flake.
  The entire set is exposed as a flake output under `lib`.

- [`packages/`](./packages) stores Nix expressions for packages that aren't in
  [nixpkgs](https://github.com/NixOS/nixpkgs) (yet).

  These packages are exposed as flake outputs under `packages`, and an overlay is defined
  that adds these packages in under `overlay`.

- Secrets are managed and provisioned by [sops-nix](https://github.com/Mic92/sops-nix/),
  which reads and decrypts `secrets/secrets.yaml`.

## Installing

[Partition and format](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning),
then mount the target filesystem to `/mnt`, import a supported SSH key, and clone this repo:

```sh
mkdir -p /mnt/etc/nixos
git clone https://github.com/i077/system /mnt/etc/nixos
```

For a new device, create a new directory under `hosts/` and add
`default.nix` (see the other hosts' configs for structure).
Then, generate a new SSH host keypair, rotate sops secrets,
and place in `/mnt/etc/ssh`.

Finally, install the configuration,
passing the name of the device:

```sh
# In /mnt/etc/nixos
./do install devicename
```

## Maintenance

[`do`](./do) is a fish script I wrote to help manage common tasks like updating
this flake and rebuilding the system configuration (`./do up`) or removing
generations more than a month old (`./do GC 30`).

I have it aliased to `sysdo` in my fish config, so I can run `sysdo [...]` from anywhere.
Here's a table of all the verbs I implemented:

| Verb            | What it does                                               |
| --------------- | ---------------------------------------------------------- |
| `clean`         | Clean up build outputs                                     |
| `check`         | Run checks on the repo                                     |
| `switch`, `s`   | Rebuild configuration and switch                           |
| `boot`, `b`     | Rebuild configuration and add boot entry                   |
| `test`, `t`     | Rebuild configuration and activate                         |
| `build`         | Just build the configuration to `./result`                 |
| `update`        | Update flake inputs and commit `flake.lock`                |
| `gc`            | Garbage-collect unreachable nix-store paths                |
| `GC [D]`        | Remove generations older than `D` days and garbage-collect |
| `upgrade`, `up` | Update and switch                                          |
| `ub`            | Update and boot                                            |
| `ut`            | Update and test                                            |
| `install name`  | Install `name`'s configuation to `/mnt`                    |
| `git ...`       | Run a git command in the repo                              |

You can also check the help function in the script itself.

## Helpful references for Nix flakes

- [3-part article](https://www.tweag.io/blog/2020-05-25-flakes/) from Eelco Dolstra himself on Tweag
- [NixOS Wiki page](https://nixos.wiki/wiki/Flakes) on flakes
- Some other peoples' flakes:
  - [`github:hlissner/dotfiles`](https://github.com/hlissner/dotfiles)
  - [`github:balsoft/nixos-config`](https://github.com/balsoft/nixos-config)
