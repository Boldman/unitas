{ config, pkgs, ...}:

# This file contains the configuration for Music Player Daemon.

{
  services.mpd = {
    enable = true;
  };
}
# vim:filesystem=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap