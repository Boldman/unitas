{ config, pkgs, lib, ...}:

{
  imports = [
#    ./alacritty.nix
    ./compton.nix
    ./direnv.nix
    ./dunst.nix
    ./firefox.nix
    ./fish.nix
    ./fzf.nix
    ./home-manager.nix
    ./htop.nix
    ./i3.nix
#	./kakoune.nix
    ./language.nix
    ./less.nix
    ./lorri.nix
    ./mpd.nix
    ./mpv.nix
    ./neovim.nix
    ./packages.nix
    ./polybar.nix
    ./rofi.nix
#    ./starship.nix
    ./sxhkd.nix
    ./taskwarrior.nix
    ./termite.nix
    ./tmux.nix
    ./xsession.nix
  ];

  nixpkgs = {
    config = import ../../../nix/config.nix;
    overlays = let
      sources = import ../../../nix/sources.nix;
      unstable = import sources.nixpkgs { config = config.nixpkgs.config; };
    in
      [
        (_: _: { inherit unstable; })
        (import sources.nixpkgs-mozilla)
        (
          _: super: {
            niv = (import sources.niv {}).niv;
            ormolu = (import sources.ormolu {}).ormolu;
          }
        )
      ];
    };

    xdg.configFile."nixpkgs/config.nix".source = ../../../nix/config.nix;
  }



# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
