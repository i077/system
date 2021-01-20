# modules/shell/gnupg.nix -- GnuPG tools
# I was once really excited about PGP, until I started using it for a year or two.
# Key management is horrid if you want to do it the proper way, no one I know really uses it
# outside of file encryption (and there are better ways to do that), and the UX in general is,
# uh, bad. 
#
# Alas, it's the most established suite of privacy tools, so I'm stuck with it for now,
# but I'm working on moving on...

{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.gnupg;
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption types;
in {
  options.modules.shell.gnupg = {
    enable = mkEnableOption "GnuPG shell";
    sshAgent = mkEnableOption "GnuPG agent as SSH agent";
    cacheTTL = mkOption {
      type = types.int;
      default = 300;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = cfg.sshAgent;
      };

      environment.shellInit = ''
        export GPG_TTY="$(tty)"
        gpg-connect-agent /bye
      '';

      hm.programs.gpg.enable = true;

      hm.services.gpg-agent = {
        enable = true;
        defaultCacheTtl = cfg.cacheTTL;
      };
    }

    (mkIf cfg.sshAgent {
      programs.gnupg.agent.enableSSHSupport = true;
      programs.ssh.startAgent = false;

      environment.shellInit = ''
        export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      '';

      hm.services.gpg-agent = {
        enableSshSupport = true;
        defaultCacheTtlSsh = cfg.cacheTTL;
      };
    })

    (mkIf config.modules.security.yubikey.enable { services.pcscd.enable = true; })

    # If using GNOME 3, use its pinentry
    (mkIf config.modules.desktop.gnome3.enable {
      hm.services.gpg-agent.pinentryFlavor = "gnome3";
      services.dbus.packages = [ pkgs.gcr ];
    })
  ]);
}
