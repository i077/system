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

    cleanup = "zap";

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
    ];

    casks = [
      "altserver"
      "bartender"
      "contexts"
      "discord"
      "firefox"
      "karabiner-elements"
      "keybase"
      "plexamp"
      "raycast"
      "stats"
      "skim"
      "visual-studio-code"
      "zoom"
      "zotero"
    ];

    masApps = {
      "Microsoft Remote Desktop" = 1295203466;
      "Reeder 5" = 1529448980;
      Tailscale = 1475387142;
      Xcode = 497799835;
    };
  };
}
