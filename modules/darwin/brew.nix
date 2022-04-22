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

    taps = [
      "1password/tap"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
    ];

    # Some default packages
    casks = [
      "1password-beta"
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
      Bitwarden = 1352778147;
      Tailscale = 1475387142;
      Xcode = 497799835;
    };
  };
}
