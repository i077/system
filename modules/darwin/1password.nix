{ ... }:

{
  homebrew = {
    taps = [ "1password/tap" "homebrew/cask-versions" ];
    casks = [ "1password-beta" "1password-cli" ];
  };

  # Source fish completions for 1password cli
  programs.fish.interactiveShellInit = ''
    command -q op; and op completion fish | source
  '';
}
