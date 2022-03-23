{ ... }:
{
  homebrew = {
    # Enable homebrew & global bundle management
    enable = true;
    autoUpdate = false;
    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
    ];

    casks = [
      "bartender"
      "contexts"
      "firefox"
      "karabiner-elements"
      "keybase"
      "plexamp"
      "raycast"
      "stats"
      "skim"
      "visual-studio-code"
      "zotero"
    ];

    masApps = {
      Xcode = 497799835;
      "Reeder 5" = 1529448980;
      Tailscale = 1475387142;
    };
  };
}
