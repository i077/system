{ config, lib, pkgs, ...}:

let
  colors = with lib;
    mapAttrs (name: value: (removePrefix "#" value)) (import ../colors.nix);

  sources = import ../../nix/sources.nix {};
in lib.mkIf config.programs.fish.enable {
  programs.fish = {
    shellAbbrs = {
      g       = "git";
      l       = "exa";
      ls      = "exa";
      la      = "exa -a";
      ll      = "exa -l";
      lL      = "exa -algiSH --git";
      lt      = "exa -lT";
      py      = "ptpython";
      t       = "tmux";
      ta      = "tmux a -t";
      userctl = "systemctl --user";
      v       = "nvim";
    };

    shellAliases = {
      # NixOS management
      nxu = "sudo nix-channel --update";
      nxs = "sudo nixos-rebuild switch";
      nxb = "sudo nixos-rebuild boot";
      nxt = "sudo nixos-rebuild test";

      # Keybase stuff
      cdkb = "cd /keybase/private/i077";
      cdkbp = "cd /keybase/public/i077";
    };

    promptInit = ''
      for file in ${sources.fish-bobthefish}/**.fish; source $file; end
      set -g theme_color_scheme terminal2
      set -g theme_nerd_fonts no
      set -g theme_display_jobs_verbose yes
      set -g theme_show_exit_status yes
      set -g theme_display_date no

      # Define custom colors
      function bobthefish_colors -S -d 'Define custom bobthefish color scheme'
        # Use terminal2 as base colorscheme
        __bobthefish_colors terminal2

        set -x color_initial_segment_exit   ${colors.fg1}       ${colors.alert}     --bold
        set -x color_initial_segment_su     ${colors.fg1}       ${colors.secondary} --bold
        set -x color_initial_segment_jobs   ${colors.fg1}       ${colors.senary}    --bold
        set -x color_path                   ${colors.bg2}       ${colors.fg1}
        set -x color_path_basename          ${colors.bg2}       ${colors.fg0}       --bold
        set -x color_path_nowrite           ${colors.fg2}       ${colors.bg1}
        set -x color_path_nowrite_basename  ${colors.fg2}       ${colors.bg0}       --bold
        set -x color_repo                   ${colors.secondary} ${colors.bg0}
        set -x color_repo_work_tree         ${colors.bg2}       ${colors.fg0}       --bold
        set -x color_repo_dirty             ${colors.alert}     ${colors.bg0}
        set -x color_repo_staged            ${colors.quinary}   ${colors.bg0}
        set -x color_vi_mode_default        ${colors.primary}   ${colors.bg1}       --bold
        set -x color_vi_mode_insert         ${colors.fg1}       ${colors.bg1}       --bold
        set -x color_vi_mode_visual         ${colors.septary}   ${colors.bg1}       --bold
        set -x color_vagrant                ${colors.septary}   ${colors.bg1}
        set -x color_username               ${colors.bg3}       ${colors.fg0}       --bold
        set -x color_hostname               ${colors.bg3}       ${colors.fg1}
        set -x color_virtualfish            ${colors.primary}   ${colors.bg1}       --bold
        set -x color_virtualgo              ${colors.primary}   ${colors.bg1}       --bold
        set -x color_desk                   ${colors.primary}   ${colors.bg1}       --bold
      end
    '';

    interactiveShellInit = ''
      fzf_key_bindings
    '';

    plugins = [
      {
        name = "z";
        src = sources.fish-z;
      }
    ];
  };
}
