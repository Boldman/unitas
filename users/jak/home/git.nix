{ config, pkgs, ...}:

# This file contains the configurations for git.

let
  cfg = config.unitas.jak;
in
{
  programs.git = {

