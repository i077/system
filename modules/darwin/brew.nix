{
  config,
  inputs,
  ...
}: {
  imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = config.system.primaryUser;
    autoMigrate = true;
    mutableTaps = false;
    taps = {
      # Manage taps as flake inputs
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };

  homebrew = {
    # Enable homebrew & global bundle management
    enable = true;
    global = {
      brewfile = true;
      autoUpdate = false;
    };

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = false;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    # Some default packages
    casks = [
      "alt-tab"
      "betterdisplay"
      "firefox"
      "ghostty"
      "homerow"
      "hyperkey"
      "jetbrains-toolbox"
      "kopiaui"
      "mac-mouse-fix"
      "mediamate"
      "stats"
      "zed"
    ];
  };
}
