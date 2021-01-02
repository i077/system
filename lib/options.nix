# lib/options.nix -- Helper functions for defining options

lib:

let inherit (lib) mkEnableOption mkOption types;
in rec {
  # Define another enable option that defaults to true
  mkEnableOpt' = s: (mkEnableOption s) // { default = true; };
}
