# This file contains pinned versions of upstream channels, overlays and modules so that the same
# version is used by NixOS, nix tools and home-manager.

{
  homeManager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "master";
    rev = "621c98f15a31e7f0c1389f69aaacd0ac267ce29e";
  };
  nixosUnstable = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs-channels.git";
    ref = "nixos-unstable";
    rev = "7827d3f4497ed722fedca57fd4d5ca1a65c38256";
  };
  nixpkgsUnstable = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs.git";
    ref = "master";
    rev = "3726e168dcbc3d199e5a71ad2a456217dac3dd1d";
  };
  mozillaOverlay = builtins.fetchGit {
    url = "https://github.com/mozilla/nixpkgs-mozilla.git";
    ref = "master";
    rev = "d46240e8755d91bc36c0c38621af72bf5c489e13";
  };
  dwarffs = builtins.fetchGit {
    url = "https://github.com/edolstra/dwarffs.git";
    ref = "master";
    rev = "531a2338101f0b6db2d9d512c3f98145f7b75397";
  };
  all-hies = builtins.fetchGit {
    url = "https://github.com/Infinisil/all-hies.git";
    ref = "master";
    rev = "c4fad117eb79305f5b8bc77a6a28562a5f8d2ca3";
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
