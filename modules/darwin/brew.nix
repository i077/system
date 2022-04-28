{ config, ... }: {
  homebrew = {
    # Enable homebrew & global bundle management
    enable = true;
    autoUpdate = false;
    global = {
      brewfile = true;
      noLock = true;
    };

    cleanup = "zap";

    taps = [ "homebrew/bundle" "homebrew/cask" "homebrew/cask-fonts" "homebrew/core" ];

    # Some default packages
    casks = [
      "bartender"
      "contexts"
      "firefox"
      "fork"
      "iterm2"
      "karabiner-elements"
      "keybase"
      "plexamp"
      "raycast"
      "stats"
      "visual-studio-code"
    ];

    masApps = {
      Tailscale = 1475387142;
      Xcode = 497799835;
    };
  };
}
