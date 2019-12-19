{ config, lib, pkgs, ...}:

let
  custompkgs = import ../../packages {};
in lib.mkIf config.programs.fish.enable {
  programs.fish = {
    shellAbbrs = {
      g = "git";
      hm = "home-manager";
      l = "exa";
      la = "exa -a";
      ll = "exa -l";
      lL = "exa -algiSH --git";
      lt = "exa -lT";
      t = "tmux";
      ta = "tmux a -t";
      td = "todoist";
      userctl = "systemctl --user";
      v = "nvim";
    };

    shellAliases = {
      # NixOS management
      hms = "home-manager switch";
      nxu = "nix-channel --update && sudo nix-channel --update";
      nxs = "sudo nixos-rebuild switch";
      nxb = "sudo nixos-rebuild boot";

      # Keybase stuff
      cdkb = "cd /keybase/private/i077";
      cdkbp = "cd /keybase/public/i077";
    };

    shellInit = ''
      for file in ${custompkgs.budspencer}/lib/budspencer/*.fish; source $file; end
      fzf_key_bindings
    '';
  };

  # Enable direnv integration with fish
  programs.direnv.enableFishIntegration = true;
}
