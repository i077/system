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
    ];

    # Some default packages
    casks = [
      "betterdisplay"
      "firefox"
      "ghostty"
      "hyperkey"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "kopiaui"
      "mac-mouse-fix"
      "mediamate"
      "plexamp"
      "pocket-casts"
      "raycast"
      "stats"
      "vivaldi"
      "zed"
    ];
  };
}
