{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # General System Utilities
    wget file unzip

    # Dotfiles
    yadm unstable.antibody

    # Version Control
    git gnupg pinentry_ncurses

    # Development Environment
    vim tmux ctags

    # Browser
    firefox

    # Fonts
    meslo-lg
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.zsh.enable = true;
}