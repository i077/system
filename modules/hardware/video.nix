{ config, lib, options, pkgs, ... }:

let
  cfg = config.modules.hardware.video;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
in {
  options.modules.hardware.video = {
    gpu = mkOption {
      description = "Type of GPU configuration on the device.";
      type = types.enum [ "intel" "nvidia" "optimus" ];
    };

    optimusMode = mkOption {
      description = ''
        Whether to use GPU in offload or sync mode for Optimus laptops.
        See https://nixos.wiki/wiki/Nvidia for details.
      '';
      type = types.nullOr (types.enum [ "offload" "sync" ]);
    };

    hidpi.enable = mkEnableOption "HiDPI support";
  };

  config = mkMerge [
    {
      assertions = [{
        assertion = cfg.gpu != "optimus" || cfg.optimusMode != null;
        message = "Optimus mode must be set if gpu type is set to 'optimus'.";
      }];

      hardware.video.hidpi.enable = cfg.hidpi.enable;
      user.extraGroups = [ "video" ];
    }

    (mkIf (cfg.gpu == "nvidia") {
      # Enable NVIDIA drivers
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.opengl.driSupport32Bit = true;
      hardware.nvidia.modesetting.enable = true;

      # Prevent screen tearing
      services.xserver.screenSection = ''
        Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
      '';
    })

    (mkIf (cfg.gpu == "optimus") (mkMerge [
      {
        hardware.nvidia.prime = {
          # Output from lspci -- I only have one optimus device, so I'll just keep this here...
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.opengl.driSupport32Bit = true;
        hardware.nvidia.modesetting.enable = true;

        # Add extra packages to openGL to leverage intel hardware decoding
        hardware.opengl.extraPackages = with pkgs; [
          (vaapiIntel.override { enableHybridCodec = true; })
          vaapiVdpau
          libvdpau-va-gl
          intel-media-driver
        ];
      }

      (mkIf (cfg.optimusMode == "offload") {
        # Add nvidia-offload script
        environment.systemPackages = [
          (pkgs.writeShellScriptBin "nvidia-offload" ''
            export __NV_PRIME_RENDER_OFFLOAD=1
            export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
            export __GLX_VENDOR_LIBRARY_NAME=nvidia
            export __VK_LAYER_NV_optimus=NVIDIA_only
            exec -a "$0" "$@"
          '')
        ];

        hardware.nvidia.prime.offload.enable = true;
      })

      (mkIf (cfg.optimusMode == "sync") { hardware.nvidia.prime.sync.enable = true; })
    ]))

    (mkIf (cfg.gpu == "intel") {
      services.xserver.videoDrivers = [ "modesetting" ];
      services.xserver.useGlamor = true;

      # Add extra packages to openGL to leverage intel hardware decoding
      hardware.opengl.extraPackages = with pkgs; [
        (vaapiIntel.override { enableHybridCodec = true; })
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    })
  ];
}
