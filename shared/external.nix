# This file contains pinned versions of upstream channels, overlays and modules so that the same
# version is used by NixOS, nix tools and home-manager.

{
  homeManager = builtins.fetchGit {
    # Temporarily use our fork of upstream's master to specify starship package.
    # Remember to change the channels back on non-NixOS systems when going back
    # to upstream.
    url = "https://github.com/davidtwco/home-manager.git";
    ref = "starship-package";
    rev = "c4b77d90383e8777234793e32089b3acab28762f";
  };
  nixosUnstable = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs-channels.git";
    ref = "nixos-unstable";
    rev = "7827d3f4497ed722fedca57fd4d5ca1a65c38256";
  };
  nixpkgsUnstable = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs.git";
    ref = "master";
    rev = "438a0cd40b2e40c0b85f6ea2eafaca094bd16bae";
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
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
