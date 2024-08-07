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
      "contexts"
      "duplicacy-web-edition"
      "firefox"
      "iterm2"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "karabiner-elements"
      "monitorcontrol"
      "mac-mouse-fix"
      "plexamp"
      "raycast"
      "stats"
      "visual-studio-code"
      "zed"
    ];
  };
}
