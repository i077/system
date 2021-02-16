{ config, lib, ... }:

let
  cfg = config.modules.shell.starship;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.starship.enable = mkEnableOption "Starship prompt";

  config = mkIf cfg.enable {
    hm.programs.starship = {
      enable = true;
      enableFishIntegration = config.modules.shell.fish.enable;
      settings = {
        status.disabled = false;
        aws.symbol = " ";
        conda.symbol = " ";
        dart.symbol = " ";
        directory.read_only = " ";
        docker.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        golang.symbol = " ";
        haskell.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        memory_usage.symbol = " ";
        nim.symbol = " ";
        nix_shell.symbol = " ";
        nodejs.symbol = " ";
        package.symbol = " ";
        perl.symbol = " ";
        php.symbol = " ";
        python.symbol = " ";
        ruby.symbol = " ";
        rust.symbol = " ";
        swift.symbol = "ﯣ ";
      };
    };
  };
}
