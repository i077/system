{...}: {
  homebrew = {
    # The GUI app insists on being in /Applications, and the CLI insists that the integration requires it to be in
    # /usr/local/bin, so we just install both via Homebrew
    casks = ["1password-beta" "1password-cli"];
  };

  # Source fish completions for 1password cli
  programs.fish.interactiveShellInit = ''
    command -q op; and op completion fish | source
  '';
}
