{ ... }:

{
  require = [ ../profiles/personal.nix ./hardware-configuration.nix ];

  users.users.root.initialHashedPassword =
    "$6$U432DHy9wMaAyiiC$l.1J5mpNJpfIN9dL74jbQY07Wy9v1iBsUSTW8.A4HI2mA7TnHeqyIJmjwJzeaBQvJIXvX2csdfGukOLauab3U.";

  user.initialHashedPassword =
    "$6$94Ai90YZt$HPNB1HuOVlJ/owkyFtUINk3WGAxgKwMDTYNjL4c8zlqdO9mreQFfTWOMtOo4vL1ioaRbtSkX5gaQ41Ncl.gpo.";

  modules = {
    desktop = {
      utils = {
        autorandr.profiles = {
          "main" = {
            fingerprint = {
              DP-4 =
                " 00ffffffffffff00220e683400000000191c0104a5351e783aa135a35b4fa327115054a10800d1c081c0a9c0b3009500810081800101023a801871382d40582c45000f282100001e000000fd00323c1e5011010a202020202020000000fc00485020453234330a2020202020000000ff00434e4b383235314648570a20200010";
              HDMI-0 =
                " 00ffffffffffff00220e693401010101191c010380351e782aa135a35b4fa327115054a10800d1c081c0a9c0b3009500810081800101023a801871382d40582c45000f282100001e000000fd00323c1e5011000a202020202020000000fc00485020453234330a2020202020000000ff00434e4b38323531464a430a20200153020319b149901f0413031202110167030c0010000022e2002b023a801871382d40582c45000f282100001e023a80d072382d40102c45800f282100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001";
            };

            config = {
              DP-4 = {
                enable = true;
                primary = true;
                position = "0x420";
                mode = "1920x1080";
                dpi = 96;
                rate = "60.00";
              };
              HDMI-0 = {
                enable = true;
                primary = false;
                position = "1920x0";
                mode = "1920x1080";
                dpi = 96;
                rate = "60.00";
                rotate = "right";
              };
            };
          };
        };
        polybar.bar1Monitor = "DP-4";
      };
    };

    hardware = {
      cpu.vendor = "amd";
      fs = {
        ssd.enable = true;
        swapsize = 4096;
      };
      keyboard.ergodox.enable = true;
      video = { gpu = "nvidia"; };
    };
  };
}
