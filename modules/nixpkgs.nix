{ config, device, inputs, lib, pkgs, ... }:

{
  # Link each input to /etc/sources
  environment.etc = (lib.mapAttrs'
    (name: value: (lib.nameValuePair "sources/${name}" { source = value; }))
    inputs);

  nix = {
    nixPath = lib.mkForce [
      "nixpkgs=/etc/sources/nixpkgs"
      "home-manager=/etc/sources/home-manager"
    ];

    # Auto-optimize nix store
    optimise.automatic = true;

    # Grant suderos rights with the nix daemon
    trustedUsers = [ "root" "@wheel" ];

    # Use flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry.nixpkgs = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      flake = inputs.nixpkgs;
    };

    binaryCaches = [ "https://cache.nixos.org" "https://srid.cachix.org" ];
    binaryCachePublicKeys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "srid.cachix.org-1:MTQ6ksbfz3LBMmjyPh0PLmos+1x+CdtJxA/J2W+PQxI="
    ];
  };

  nixpkgs.config = import ../nixpkgs-config.nix;

  # Include devel outputs for packages
  documentation.dev.enable = true;

  nixpkgs.overlays = [
    # Overlay for temporary fixes to broken packages on nixos-unstable
    (self: super:
      let
        importNixpkgsRev = { rev, sha256 }:
          import (builtins.fetchTarball {
            name = "nixpkgs-src-" + rev;
            url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
            inherit sha256;
          }) {
            inherit (device) system;
            inherit (config.nixpkgs) config;
            overlays = [ ];
          };

        nixpkgs-b3c3a0b = importNixpkgsRev {
          rev = "b3c3a0bd1835a3907bf23f5f7bd7c9d18ef163ec";
          sha256 = "0b9n5arqr3pzyg1ws0wf84zlczgllxnhjm1mzddd1qk5w5nw7fcy";
        };
      in {
        inherit (nixpkgs-b3c3a0b) quodlibet-full;

        # Patch for NVIDIA on 5.7
        linuxPackages_latest = super.linuxPackages_latest.extend (self: super: {
          nvidiaPackages = super.nvidiaPackages // {
            stable = super.nvidiaPackages.stable.overrideAttrs (old: {
              patches = [
                (pkgs.fetchpatch {
                  name = "nvidia-kernel-5.7.patch";
                  url = "https://gitlab.com/snippets/1965550/raw";
                  sha256 =
                    "03iwxhkajk65phc0h5j7v4gr4fjj6mhxdn04pa57am5qax8i2g9w";
                })
              ];

              passthru = {
                settings = pkgs.callPackage (import (inputs.nixpkgs
                  + "/pkgs/os-specific/linux/nvidia-x11/settings.nix")
                  self.nvidiaPackages.stable
                  "15psxvd65wi6hmxmd2vvsp2v0m07axw613hb355nh15r1dpkr3ma") {
                    withGtk2 = true;
                    withGtk3 = false;
                  };

                persistenced = pkgs.lib.mapNullable (hash:
                  pkgs.callPackage (import (inputs.nixpkgs
                    + "/pkgs/os-specific/linux/nvidia-x11/persistenced.nix")
                    self.nvidiaPackages.stable hash) { })
                  "13izz9p2kg9g38gf57g3s2sw7wshp1i9m5pzljh9v82c4c22x1fw";
              };
            });
          };
        });
      })

    (self: super: {
      vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };

      my-python3Full = super.python3Full.withPackages (pypkgs:
        with pypkgs; [
          matplotlib
          jupyter
          jupyterlab
          numpy
          rope
          setuptools
          scipy
          scikitlearn
          sympy
          cython
          jedi
          python-language-server

          ptpython
        ]);

      my-python3-i3 =
        super.python3.withPackages (pypkgs: with pypkgs; [ i3ipc ]);
    })
  ];
}
