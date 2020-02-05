{ config, pkgs, ...}:

# This file contains the configuration for termite.

{
  home.sessionVariables = { "EDITOR" = "${pkgs.kakoune}/bin/kak"; };

  programs.kakoune.enable = true;

}
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
