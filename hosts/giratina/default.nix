{ config, ... }:

{
  require = [ ../../roles/personal ./hardware-configuration.nix ];

  boot.initrd.luks.devices."cryptroot" = { preLVM = true; };

  users.users.root.initialHashedPassword =
    "$6$tCSaAe5ySE$xQn/3EZn/3Big2IrGmJSbgmisJMiOe4XtfUlr/5ZSzX9Q8OnBR9Ufnxl0IFk28GhPbRIhYkrBcfp2lMUXfPYi0";

  user.initialHashedPassword =
    "$6$13upfcwNVf5hkcJ$obo71gDJ5Pdb1k1n.rY1bIznTX9MsHnSXj7L9uFtxY3.YD82TtJ8x3.Jh0S5qyDqmk/AA83wBlm7FqZVOZseG/";

  modules = {
    desktop = {
      utils = {
        autorandr.profiles = {
          "main" = {
            fingerprint = {
              eDP1 =
                "00ffffffffffff0009e5c30600000000121a0104a5221378022e10a757549f26115054000000010101010101010101010101010101014dd000a0f0703e803020350059c21000001ae08a00a0f0703e803020350059c21000001a00000000000000000000000000000000000000000002000c2dff103ca632463aa60000000095";
            };
            config = {
              eDP1 = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "3840x2160";
                dpi = 192;
                rate = "60.00";
              };
            };
          };
          "hometv" = {
            fingerprint = {
              DP2 =
                "00ffffffffffff000a65010100000000ff130103800000780a0dc9a05747982712484c20000001010101010101010101010101010101023a801871382d40582c4500fa3d3200001e023a80d072382d40102c4580fa3d3200001e000000fc00424f5345204c530a2020202020000000fd00323c0f440f000a202020202020014902033e72320f7f031507503e1fc0570f005f7f01677f0052909f20212202030405060711121314151601837f00006c030c002000801ec047474747e2003f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000027";
              eDP1 =
                "00ffffffffffff0009e5c30600000000121a0104a5221378022e10a757549f26115054000000010101010101010101010101010101014dd000a0f0703e803020350059c21000001ae08a00a0f0703e803020350059c21000001a00000000000000000000000000000000000000000002000c2dff103ca632463aa60000000095";
            };
            config = {
              eDP1.enable = false;
              DP2 = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "1920x1080";
                dpi = 96;
                rate = "60.00";
              };
            };
          };
        };
        polybar.bar1Monitor = "eDP1";
      };
    };

    hardware = {
      cpu.vendor = "intel";
      fs = {
        ssd.enable = true;
        swapsize = 4096;
      };
      keyboard.caps2esc.enable = true;
      laptop.enable = true;
      video = {
        gpu = "optimus";
        optimusMode = "offload";
        hidpi.enable = true;
      };
    };

    services = {
      backup = { excludes = [ "Music/" ]; };
      onedrive = {
        enable = true;
        sync_dir = "/home/${config.user.name}/OneDrive";
      };
    };
  };
}
