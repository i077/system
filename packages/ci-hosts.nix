# Since this flake's nix-darwin configs depend on pkgs.requireFile derivations,
# and those derivations use private sources, for each configuration,
# extend it to exclude such derivations for the CI system to build.
{
  pkgs,
  flake,
  pname,
  ...
}: let
  symlinkSystemsCmds =
    pkgs.lib.concatMapAttrsStringSep "\n"
    (name: config: "ln -s ${(config.extendModules {modules = [{lib.env.isCi = true;}];}).system} $out/${name}")
    flake.darwinConfigurations;
in
  pkgs.runCommand pname {
    meta.platforms = pkgs.lib.platforms.darwin;
  } ''
    mkdir $out
    ${symlinkSystemsCmds}
  ''
