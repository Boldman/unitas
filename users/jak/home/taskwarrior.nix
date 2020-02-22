{ pkgs, ... }:

# This file contains the configuration for info.

{
  home.packages = with pkgs; [ python38Packages.bugwarrior timewarrior tasknc tasksh task-open vit ];
  programs.taskwarrior = {
    enable = true;
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
