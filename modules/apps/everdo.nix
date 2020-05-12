{ config, pkgs, lib, ... }:

{
  home-manager.users.imran = {
    home.packages = [ pkgs.everdo ];

    xdg.configFile."everdo/everdo.key".text = config.private.everdo.key;
    xdg.configFile."everdo/encryption-key".text =
      config.private.everdo.encryptionKey;
    xdg.configFile."everdo/jwt".text = config.private.everdo.jwt;
  };
}
