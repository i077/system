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
      "antinote"
      "betterdisplay"
      "dockdoor"
      "firefox"
      "ghostty"
      "homerow"
      "hyperkey"
      "jetbrains-toolbox"
      "kopiaui"
      "mac-mouse-fix"
      "mediamate"
      "raycast"
      "stats"
      "thaw"
      "vivaldi"
      "zed"
    ];
  };
}
