{config, ...}: {
  homebrew = {
    # Enable homebrew & global bundle management
    enable = true;
    global = {
      brewfile = true;
      autoUpdate = false;
    };

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/cask-drivers"
      "homebrew/cask-versions"
    ];

    # Some default packages
    casks = [
      "bartender"
      "contexts"
      "duplicacy-web-edition"
      "firefox"
      "iterm2"
      "jetbrains-toolbox"
      "karabiner-elements"
      "monitorcontrol"
      "mac-mouse-fix"
      "plexamp"
      "raycast"
      "stats"
      "visual-studio-code"
      "zed"
    ];

    masApps = {
      Tailscale = 1475387142;
      Xcode = 497799835;
      "Things 3" = 904280696;
    };
  };
}
