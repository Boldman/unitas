{ config, pkgs, ...}:

# This file contains the configuration for firefox.

{
  home.sessionVariables = { "BROWSER" = "${pkgs.firefox}/bin/firefox"; };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    };
}
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
