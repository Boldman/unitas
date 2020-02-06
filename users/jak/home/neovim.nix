{ config, pkgs, lib, ... }:

# This file contains the configuration for NeoVim.

{
  home.sessionVariables."EDITOR" = "${config.programs.neovim.finalPackage}/bin/nvim";

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    package = pkgs.neovim-unwrapped;
    plugins =
			let
          sources = import ../../../nix/sources.nix;
        in
          # Define our own plugin list with pinned versions so that we can guarantee
          # a working configuration. Some plugins require `dontBuild` as they include
          # `Makefile`s to run tests and build docs.
          [
						# Sensible defaults for Neovim.
            (pkgs.vimUtils.buildVimPlugin { name = "vim-sensible"; src = sources.neovim-sensible; })
            # Read .editorconfig file in directories
            (pkgs.vimUtils.buildVimPlugin { name = "editorconfig-vim"; src = sources.editorconfig-vim; })
						# Helper for managing personal wiki
            (pkgs.vimUtils.buildVimPlugin { name = "vimwiki"; src = sources.vimwiki; })
					];
		extraConfig =
		''
			""General settings
       "Show relative numbers and current line number
       set number
			 set relativenumber
       " Shortcutting split navigation, saving a keypress:
       map <C-h> <C-w>h
       map <C-j> <C-w>j
       map <C-k> <C-w>k
       map <C-l> <C-w>l

       "Vimwiki Settings
       let g:vimwiki_list = [{'path': '~/unitas/wiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
       "EditorConfig settings
       let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

		'';
  };

}

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
