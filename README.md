# NixOS Configuration

![Build and cache NixOS configurations](https://github.com/i077/system/workflows/Build%20and%20cache%20NixOS%20configurations/badge.svg)

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

- [`hm-modules/`](./hm-modules) stores home-manager modules that I use in my configuration,
  like one for [rotating the wallpaper](./hm-modules/gnome-background.nix) in GNOME.
  They could potentially be merged upstream into home-manager.

  Each of these modules is exposed as a flake output under `homeManagerModules`.

- [`roles/`](./roles) stores configuration for high-level attributes for my machines.
  For example, a personal role is defined that adds personal packages.
  These roles enable specific config from `modules/` as well as NixOS options.

- Each directory in [`hosts/`](./hosts) stores device-specific configuration
  such as for [giratina](./hosts/giratina), my current laptop.
  Essentially each host's config enables specific modules from `modules/`,
  which in turn changes specific NixOS options.

  Each host's configuration is exposed as a flake output under `nixosConfigurations`.

- [`lib/`](./lib) defines a bunch of helper functions I used throughout this flake.
  The entire set is exposed as a flake output under `lib`.

- [`packages/`](./packages) stores Nix expressions for packages that aren't in
  [nixpkgs](https://github.com/NixOS/nixpkgs) (yet).

  These packages are exposed as flake outputs under `packages`, and an overlay is defined
  that adds these packages in under `overlay`.

- [`bin/`](./bin) is a collection of shell scripts I find useful.
  These are usually written with fish.

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
./bin/sysdo install devicename
```

## Maintenance

[`sysdo`](./bin/sysdo) is a fish script I wrote to help manage common tasks like updating
this flake and rebuilding the system configuration (`sysdo up`) or removing
generations more than a month old (`sysdo GC 30`).

Here's the help text:

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
        install N       Install N's configuration to /mnt
    up, upgrade         Run update and switch
        ub              Run update and boot
        ut              Run update and test
```

## Continuous Integration

Workflows are setup via GitHub Actions to:

- Evaluate the NixOS configurations present in this flake and push them to a binary cache,
  so that when I evaluate on my machines, they pull from that cache rather than doing the builds
  themselves. This runs against new commits pushed to the `master` branch and new pull requests.
  This workflow is specified in [`.github/workflows/build.yml`](./.github/workflows/build.yml).
- Update flake inputs every day (and upon manual trigger).
  If any of the inputs have updated, push the update commit to a new branch and open a pull request
  (if one does not already exist).
  GitHub will run the first workflow against this new PR, caching the evaluations so that they are
  ready when the commit is merged.
  This workflow is specified in [`.github/workflows/update.yml`](./.github/workflows/update.yml).
- Bisect the nixpkgs repository to find which commit "broke" my system.
  If a flake update commit results in a failed system build, this usually happens because something
  broke in nixpkgs. I can manually trigger this workflow against that update commit,
  and it will bisect against the old and new hashes of nixpkgs, trying to build my config
  at each step until git finds the first "bad" commit.

## Helpful references for Nix flakes

- [3-part article](https://www.tweag.io/blog/2020-05-25-flakes/) from Eelco Dolstra himself on Tweag
- [NixOS Wiki page](https://nixos.wiki/wiki/Flakes) on flakes
- Some other peoples' flakes:
  - [`github:hlissner/dotfiles`](https://github.com/hlissner/dotfiles)
  - [`github:balsoft/nixos-config`](https://github.com/balsoft/nixos-config)
