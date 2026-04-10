{
  inputs,
  pkgs,
  ...
}:
inputs.treefmt-nix.lib.mkWrapper pkgs {
  projectRootFile = ".git/config";
  programs.alejandra.enable = true;
  programs.prettier.enable = true;
  programs.stylua.enable = true;
  programs.just.enable = true;
  programs.fish_indent.enable = true;
  programs.fish_indent.includes = (
    pkgs.lib.pipe ./bin [
      builtins.readDir # Read the ./bin directory
      builtins.attrNames # Just get the names of the files
      (map (x: "bin/${x}")) # Map names to their actual paths relative to repo's root
    ]
  );
}
