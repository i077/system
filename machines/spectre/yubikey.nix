{ config, pkgs, ...}:

{
  # Access YubiKey as user
  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];

  # Enable use with GPG
  services.pcscd.enable = true;
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  # Use with SSH
  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
