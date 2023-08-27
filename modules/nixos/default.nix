# Defaults for all NixOS configurations
{...}: {
  imports = [../broken-overlay.nix ../nix-settings.nix ];

  system.stateVersion = "20.09";

  time.timeZone = "America/New_York";

  # OpenSSH configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  programs.mosh.enable = true;

  nixpkgs.config.allowUnfree = true;
}
