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
      "plexamp"
      "raycast"
      "stats"
      "skim"
      "visual-studio-code"
      "zotero"
    ];
  };
}
