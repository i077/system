{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
  readVimSection = file: builtins.readFile (./nvim + "/${file}.vim");
in
{
  programs.neovim = {
    enable = true;
    package = unstable.neovim;
    plugins = with unstable.vimPlugins; [
      # Editor
      sensible                    # Sensible defaults
      repeat	            		# Repeatable plugin actions
      surround            		# Surround text
      commentary        			# Comment code with 'gcc'
      easy-align        			# Alignment plugin
      easymotion        			# Enhanced motions
      vim-indent-object             # Use indents as motions

      # Extensions
      fugitive		            # Git wrapper
      vim-dispatch                # Asynchronous job runner
      fzf-vim			           	# Fuzzy entry selection
      denite-nvim		           	# Async unite interface
      nvim-yarp		           	# Remote plugin framework
      nerdtree		           	# File sidebar

      # UI + Colorschemes
      airline	                    # Smarter tabline
      vim-airline-themes          # Airline themes (automatches colorscheme)
      base16-vim                  # Base16
      falcon	                    # Falcon
      gruvbox	                    # Gruvbox
      vim-monokai-pro             # Monokai Pro
      awesome-vim-colorschemes    # Collection of colorschemes

      # Languages
      ale                         # Async linting framework
      coc-nvim                    # Conquerer of completion
      coc-python
      coc-vimtex
      LanguageClient-neovim	    # Integrations with language clients
      polyglot		            # Multiple language support
      vimtex			            # LaTeX support
      vim-pandoc                  # Pandoc support
      vim-pandoc-syntax           # Pandoc syntax support
      vim-slime		        	# Scheme support

      # Prose
      goyo				        # Distraction-free editing
      limelight-vim               # Focus mode for vim
      vim-pencil			        # Writing tool for vim
    ];

    extraConfig = ''
      ${readVimSection "editor"}
      ${readVimSection "ui"}
      ${readVimSection "mappings"}
      ${readVimSection "syntax"}
      ${readVimSection "functions"}
    '';
  };
}
