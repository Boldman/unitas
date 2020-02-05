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
						# Helper for managing personal wiki
            (pkgs.vimUtils.buildVimPlugin { name = "vimwiki"; src = sources.vimwiki; })
					];
		extraConfig =
		''
			 set number
			 set relativenumber
       
       "Vimwiki Settings
       let g:vimwiki_list = [{'path': '~/unitas/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

		'';
  };

}

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
