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
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
      "homebrew/cask-drivers"
      "homebrew/cask-versions"
    ];

    # Some default packages
    casks = [
      "alt-tab"
      "bartender"
      "contexts"
      "duplicacy-web-edition"
      "firefox"
      "iterm2"
      "karabiner-elements"
      "keybase"
      "logseq"
      "logi-options-plus"
      "monitorcontrol"
      "neovide"
      "plexamp"
      "raycast"
      "remarkable"
      "stats"
      "sublime-merge"
      "visual-studio-code"
      "wireshark"
    ];

    masApps = {
      Tailscale = 1475387142;
      Xcode = 497799835;
      "Things 3" = 904280696;
    };
  };
}
