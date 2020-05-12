{ pkgs, ... }:

{
  home-manager.users.imran = {
    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: with exts; [
        pass-audit
        pass-checkup
        pass-genphrase
        pass-update
      ]);
      settings = {
        PASSWORD_STORE_DIR = "/home/imran/.password-store";
      };
    };

    # Add gopass
    home.packages = [ pkgs.gopass ];
  };
}
