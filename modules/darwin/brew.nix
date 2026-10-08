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

    # Some default packages
    casks = [
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
