{ config, pkgs, ... }:

# This file contains the configuration for the Xsession.

let 
  cfg = config.unitas.jak;
in {
  xsession = {
    enable = !cfg.dotfiles.headless;
    initExtra = ''
      # Set wallpaper.
    '';
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      size = 24;
    };
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
