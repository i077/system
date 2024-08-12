{...}: {
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

    taps = [
      "homebrew/bundle"
      "homebrew/cask-versions"
    ];

    # Some default packages
    casks = [
      "betterdisplay"
      "contexts"
      "duplicacy-web-edition"
      "firefox"
      "hyperkey"
      "iterm2"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "mac-mouse-fix"
      "mediamate"
      "plexamp"
      "raycast"
      "stats"
      "visual-studio-code"
      "zed"
    ];
  };
}
