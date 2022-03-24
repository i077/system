{ ... }: {
  environment.systemPath = [ "${config.homebrew.brewPrefix}" ];

  homebrew = {
    # Enable homebrew & global bundle management
    enable = true;
    autoUpdate = false;
    global = {
      brewfile = true;
      noLock = true;
    };

    cleanup = "zap";

    taps = [ "homebrew/bundle" "homebrew/cask" "homebrew/cask-fonts" "homebrew/core" ];
  };
}
