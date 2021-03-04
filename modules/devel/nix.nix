# modules/devel/nix.nix -- Nix-related development tools

{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.nix;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.devel.nix.enable = mkEnableOption "Nix development tools";

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      manix
      niv
      nixfmt
      nix-diff
      nixpkgs-review

      # Shell script to update nix-index database from Mic92's repo
      (pkgs.writeShellScriptBin "nix-index-update" ''
        tag=$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --tags --sort='v:refname' \
          https://github.com/Mic92/nix-index-database \
          | awk 'END {match($2, /([^/]+)$/, m); print m[0]}')
        curl -L "https://github.com/Mic92/nix-index-database/releases/download/$tag/files" -o $XDG_RUNTIME_DIR/files-$tag
        mv $XDG_RUNTIME_DIR/files-$tag $HOME/.cache/nix-index/files
      '')
      nix-index
    ];
  };
}
