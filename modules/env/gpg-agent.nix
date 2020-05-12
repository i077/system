{ ... }:

{
  home-manager.users.imran.services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
  };
}
