{ config, pkgs, ...}:

# This file contains the configuration for sxhkd.
let
  var = config.home.sessionVariables;
in
{
  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + Return" = "${var.TERMINAL}"; 
      "super + d" = "rofi_drun"; #need to change to "launcher" variable
      "super + w" = "${var.BROWSER}";
    };
  };
}
# vim:filesystem=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
