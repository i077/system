# lib/default.nix -- This is used to extend nixpkgs' lib set to include some functions
# defined in lib/ that I used throughout my config.

# inputs.nixpkgs.lib is passed in here
lib:

{
  attrsets = import ./attrsets.nix lib;
  files = import ./files.nix lib;
  options = import ./options.nix lib;
}
