{ config, pkgs, ...}:

# This file contains the configurations for git.

let
  cfg = config.unitas.jak;
in
{
  home.packages = with pkgs.gitAndTools; [ git-bug git-dit ];
  programs.git = {
    aliases = {
      ps = "push";
      save = "stash save --include-untracked";
    };
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = cfg.email.address;
    userName = cfg.name;
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
