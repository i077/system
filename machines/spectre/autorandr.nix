{ config, lib, pkgs, ... }:

{
  home-manager.users.imran.programs.autorandr.profiles = {
    "main" = {
      fingerprint = {
        eDP-1-1 = "00ffffffffffff0009e5c30600000000121a0104a5221378022e10a757549f26115054000000010101010101010101010101010101014dd000a0f0703e803020350059c21000001ae08a00a0f0703e803020350059c21000001a00000000000000000000000000000000000000000002000c2dff103ca632463aa60000000095";
      };
      config = {
        eDP-1-1 = {
          enable = true;
          primary = true;
          position = "0x0";
          mode = "3840x2160";
          dpi = 192;
          rate = "60.00";
        };
      };
    };
  };
}
