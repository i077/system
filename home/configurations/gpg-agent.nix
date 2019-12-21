{ config, lib, pkgs, ... }:

lib.mkIf config.services.gpg-agent.enable {
  services.gpg-agent = {
    enableSshSupport = true;
    defaultCacheTtl = 300;
  };
}
