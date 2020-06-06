{ config, device, pkgs, ... }:

{
  home-manager.users.imran = {
    # Import custom home-modules
    imports = with builtins;
      map (name: ../hm-modules + "/${name}")
      (attrNames (readDir ../hm-modules));

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;

    xdg.configFile."nixpkgs/config.nix".source = ../../nixpkgs-config.nix;

    # Manage xsession
    # xsession.enable = true;

    # Manage fonts
    fonts.fontconfig.enable = true;

    systemd.user.startServices = true;
    services.lorri.enable = true;

    # Cursor
    xsession.pointerCursor = {
      package = pkgs.pantheon.elementary-icon-theme;
      name = "elementary";
      size = 24 * (if device.isHiDPI then 2 else 1);
    };
  };

  environment.sessionVariables = {
    TERMINAL = config.defaultApplications.terminal.cmd;
    EDITOR = config.defaultApplications.editor.cmd;
    VISUAL = config.defaultApplications.editor.cmd;
  };
}
