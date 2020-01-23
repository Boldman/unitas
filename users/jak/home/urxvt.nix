{ config, pkgs, ...}:

# This file contains the configuration for urxvt.

{
  home.sessionVariables = { "TERMINAL" = "${pkgs.rxvt_unicode}/bin/urxvt"; };

  programs.urxvt.enable = true;

}
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
