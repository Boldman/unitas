{ config, pkgs, lib, ...}:

{
  imports = [
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
