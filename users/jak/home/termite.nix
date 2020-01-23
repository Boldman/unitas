{ config, pkgs, ...}:

# This file contains the configuration for termite.

{
  home.sessionVariables = { "TERMINAL" = "${pkgs.termite}/bin/termite"; };

  programs.termite.enable = true;

}
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
