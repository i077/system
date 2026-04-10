{
  inputs,
  pkgs,
  perSystem,
  ...
}:
perSystem.devshell.mkShell {
  imports = ["${inputs.devshell}/extra/git/hooks.nix"];

  name = "system";
  packages = with pkgs; [
    # Wrap nix to support flakes
    (writeShellScriptBin "nix" ''
      ${lib.getExe nixVersions.latest} --extra-experimental-features "nix-command flakes" "$@"
    '')
    cachix
    jo
    nvd
    perSystem.self.formatter
  ];

  commands = [
    {package = pkgs.just;}
  ];

  git.hooks = {
    enable = true;
    pre-commit.text = pkgs.lib.getExe perSystem.self.formatter;
  };
}
