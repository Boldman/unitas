{ pkgs, ...}:

# This file contains the configuration for direnv.

{
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
