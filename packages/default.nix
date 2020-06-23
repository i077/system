{ device, lib, inputs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      everdo = self.callPackage ./pkgs/everdo.nix { };
      obsidian = self.callPackage ./pkgs/obsidian.nix { };
      write_stylus = self.callPackage ./pkgs/write_stylus.nix { };
      nerdfonts-iosevka = self.callPackage ./pkgs/nerdfonts-iosevka.nix { };

      neuron = (import (inputs.neuron + "/project.nix") {
        inherit (device) system;
      }).ghc.neuron;

      vimPlugins = super.vimPlugins // {
        neuron-vim = self.vimUtils.buildVimPluginFrom2Nix {
          pname = "neuron.vim";
          version = inputs.neuron-vim.rev;
          src = inputs.neuron-vim;
          patches = [(self.writeTextFile {
            name = "neurom-vim.patch";
            text = ''
              diff --git a/plugin/neuron.vim b/plugin/neuron.vim
              index 234a35b..82e5c1f 100644
              --- a/plugin/neuron.vim
              +++ b/plugin/neuron.vim
              @@ -11,8 +11,6 @@ if exists("g:loaded_neuron_vim")
               endif
               let g:loaded_neuron_vim = 1
               
              -call neuron#refresh_cache()
              -
               let g:neuron_no_mappings  = get(g:, 'neuron_no_mappings', 0)
               let g:style_virtual_title = get(g:, 'style_virtual_title', 'Comment')
               let g:fzf_options         = get(g:, 'fzf_options', ['-d',':','--with-nth','2'])
            '';
          })];
        };
      };
    })
  ];
}
