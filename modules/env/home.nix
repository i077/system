{ config, device, pkgs, ... }:

{
  require = [
    # Base home config
    ./packages.nix
    
    # Shell
    ./fish.nix

    # Shell tools
    ./broot.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./password-store.nix
    ./rclone.nix

    # Development
    ./python.nix

    # Desktop environment & services
    ./gnome3.nix
    ./gpg-agent.nix
    ./onedrive.nix

    # Apps
    ../apps/alacritty.nix
    ../apps/defaults.nix
    ../apps/everdo.nix
    ../apps/firefox.nix
    ../apps/keybase.nix
    ../apps/neovim
    ../apps/neuron.nix
    ../apps/ptpython.nix
    ../apps/tmux.nix
    ../apps/zathura.nix
  ];

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
