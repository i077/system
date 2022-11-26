# This module loads in an overlay that replaces currently broken packages with ones from
# a previous revision of nixpkgs that is known to build successfully (according to hydra.nixos.org).
# It's useful when a minor package (e.g. a small CLI tool) in the system's closure is broken and
# prevents the entire profile from building.
#
# The data containing the actual broken packages are contained in ./broken-overlay-data.json and is
# updated using the nix-lastgoodrev script in the bin directory.
# It comes in the following form:
#   {
#     "attr": {
#       "system-double": {
#         "nixpkgs_rev": "<git commit id>",
#         "nixpkgs_hash": "<hash of nixpkgs produced by nix flake prefetch>"
#         "pname": "<name>-<version>",
#         "hydra_build": <id of last successful hydra build>,
#         "build_date": "YYYY-MM-DD"
#       }
#     }
#   }
# I could have the data be in the form "system-double" -> "attr" to make it easier to work with,
# but it would be harder to tell at a glance which packages are being replaced across all systems.
# Perhaps this isn't as useful, so maybe I'll change this in the future.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  currentSystem = config.nixpkgs.system;

  overlayData = builtins.fromJSON (builtins.readFile ./broken-overlay-data.json);
  # Filter overlay data by current system, so this will look like
  #   { "attr": { "nixpkgs_rev": ..., }, ... }
  overlayDataForSystem =
    builtins.mapAttrs (n: v: v.${currentSystem})
    (lib.filterAttrs (n: v: builtins.hasAttr currentSystem v) overlayData);

  # Function to import nixpkgs at a specified commit (I know, IFD...)
  nixpkgsRev = rev: hash:
    import (pkgs.fetchFromGitHub {
      name = "nixpkgs-src-" + rev;
      owner = "NixOS";
      repo = "nixpkgs";
      inherit rev hash;
    }) {inherit (config.nixpkgs) config system;};

  # Function to check if a package is still broken in this flake's nixpkgs input
  # Note: This is a really ugly hack using IFD and an unsafe function,
  # but ideally there isn't more than one or two broken packages at a time so does it really matter?
  packageStillBroken = prevpkgs: attr: let
    drvPath = prevpkgs.${attr}.drvPath;
  in
    import (pkgs.runCommand "try-build-${attr}" {} ''
      ${lib.getExe pkgs.nix} build ${
        builtins.unsafeDiscardStringContext drvPath
      } && echo false > $out || echo true > $out
    '');
in {
  nixpkgs.overlays = [
    (final: prev:
      # Map each package's last good revision data to an actual derivation from that revision
        builtins.mapAttrs (attr: data:
          if packageStillBroken prev attr
          then (nixpkgsRev data.nixpkgs_rev data.nixpkgs_hash).${attr}
          else throw "${attr} builds successfully, but is still in broken overlay")
        overlayDataForSystem)
  ];
}
