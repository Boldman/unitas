{ config, pkgs, ...}:

# This file contains the configuration for taskwarrior.

{


  home.packages = with pkgs; [ python38Packages.bugwarrior vit task-open ];
  programs.taskwarrior = {
    enable = true;
  };


}
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
