# Since this flake's nix-darwin configs depend on pkgs.requireFile derivations,
# and those derivations use private sources, for each configuration,
# extend it to exclude such derivations for the CI system to build.
{
  pkgs,
  flake,
  pname,
  ...
}:
pkgs.symlinkJoin {
  name = pname;
  paths =
    map
    (c: (c.extendModules {modules = [{lib.env.isCi = true;}];}).system)
    (builtins.attrValues flake.darwinConfigurations);

  meta.platforms = pkgs.lib.platforms.darwin;
}
