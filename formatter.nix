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
  settings.formatter.fish = {
    command = "${pkgs.fish}/bin/fish_indent";
    options = ["--write"];
    includes =
      [
        "*.fish"
      ]
      ++
      # Exclude non-fish scripts in ./bin from formatter
      (pkgs.lib.pipe ./bin [
        builtins.readDir # Read the ./bin directory
        builtins.attrNames # Just get the names of the files
        (map (x: "bin/${x}")) # Map names to their actual paths relative to repo's root
      ]);
  };
  settings.formatter.just = {
    command = pkgs.lib.getExe pkgs.just;
    options = [
      "--fmt"
      "--unstable"
      "-f"
    ];
    includes = ["Justfile"];
  };
}
