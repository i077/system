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
      "gitup"
      "iterm2"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keybase"
      "monitorcontrol"
      "mac-mouse-fix"
      "plexamp"
      "raycast"
      "remarkable"
      "stats"
      "visual-studio-code"
      "wireshark"
      "zed"
    ];

    masApps = {
      Tailscale = 1475387142;
      Xcode = 497799835;
      "Things 3" = 904280696;
    };
  };
}
