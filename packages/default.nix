{ lib, inputs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      everdo = self.callPackage ./pkgs/everdo.nix { };
      obsidian = self.callPackage ./pkgs/obsidian.nix { };
      write_stylus = self.callPackage ./pkgs/write_stylus.nix { };
      nerdfonts-iosevka = self.callPackage ./pkgs/nerdfonts-iosevka.nix { };

      vimPlugins = super.vimPlugins // {
        neuron-vim = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "neuron.vim";
          version = inputs.neuron-vim.rev;
          src = inputs.neuron-vim;
        };
      };
    })
  ];
}
