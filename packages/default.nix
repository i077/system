{ device, lib, inputs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      everdo = self.callPackage ./pkgs/everdo.nix { };
      obsidian = self.callPackage ./pkgs/obsidian.nix { };
      write_stylus = self.callPackage ./pkgs/write_stylus.nix { };
      nerdfonts-iosevka = self.callPackage ./pkgs/nerdfonts-iosevka.nix { };

      neuron = import inputs.neuron {
        inherit (device) system;
      };

      vimPlugins = super.vimPlugins // {
        # neuron-vim = self.vimUtils.buildVimPluginFrom2Nix {
        #   pname = "neuron.vim";
        #   version = builtins.substring 0 7 inputs.neuron-vim.rev;
        #   src = inputs.neuron-vim;
        # };
      };
    })
  ];
}
