{ config, lib, ... }:

let
  cfg = config.modules.services.sshd;
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption types;
in {
  options.modules.services.sshd = { enable = mkEnableOption "SSH access to this machine"; };

  config = mkIf cfg.enable {
    # Add authorized keys for primary user
    user.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDU6iRY3yHvhu1GeQg7AdLOsYEIpqNE2ik9u/kmHA+TmX6PsqtfGyNpiS+fEgTd8ZrFetFhUR5wmJazVw7Xjjt+K8JkXl1mUvXzbfat8AoONnr7f6cqH8+B022g7Nb3hh4/4mhCP+jIjZ9T22bIhzJGTaH18yf/L8zJK7baOpJv2jPpEyNbl4mj5AWXtYXq8tt2LHG1yiNT9HDHFHUx+XZZY2npIieiyuFNieClIkxzIyQw1j5M0D7lstz3Mqe5KyhoBZRVXSI4njCzl3YL0JQHbT3qD+9SAaq/nlWizaMM5056pdRrgqmEWyDGdrdgPzt0240NKLlxKRsplqUFeM7z imran@giratina"
    ];
  };
}
