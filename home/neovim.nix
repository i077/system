{ config, pkgs, ... }:

let
  readVimSection = file: builtins.readFile (./nvim + "/${file}.vim");
in
{
  programs.neovim = {
    enable = true;
    configure = {
      plug.plugins = with pkgs.vimPlugins; [
        # Editor
        sensible                    # Sensible defaults
        repeat	            		# Repeatable plugin actions
        surround            		# Surround text
        commentary        			# Comment code with 'gcc'
        easy-align        			# Alignment plugin
        easymotion        			# Enhanced motions

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
        awesome-vim-colorschemes    # Collection of colorschemes

        # Languages
        ale                         # Async linting framework
        deoplete-nvim               # Completion framework
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
      customRC = ''
        ${readVimSection "editor"}
      '';
    };
  };
}
