self: super:

# This file contains a custom Nix overlay, each top-level attribute defines a custom package.
#
# From the NixOS documentation:
#
# > The first argument (self) corresponds to the final package set. You should use this set
# > for the dependencies of all packages specified in your overlay. For example, all the
# > dependencies of rr in the example above come from self, as well as the overridden dependencies
# > used in the boost override.
# >
# > The second argument (super) corresponds to the result of the evaluation of the previous stages
# > of Nixpkgs. It does not contain any of the packages added by the current overlay, nor any of
# > the following overlays. This set should be used either to refer to packages you wish to
# > override, or to access functions defined in Nixpkgs. For example, the original recipe of
# > boost in the above example, comes from super, as well as the callPackage function.

let
  ccWrapperForkTarball = builtins.fetchGit {
    url = "https://github.com/davidtwco/nixpkgs.git";
    ref = "cc-wrapper/alternate-compilers";
    rev = "d3202d2f065685235af06f763496bda68a0a7062";
  };
  ccWrapperFork = import ccWrapperForkTarball { };
in {
  # Updated version of the Intel OpenCL Runtime that supports more recent versions of OpenCL.
  intel-openclrt = super.callPackage ./packages/intel-openclrt.nix { };

  # There is no `clinfo` package upstream, despite this being the most commonly used (AFAIK) tool
  # for checking device information.
  clinfo = super.callPackage ./packages/clinfo.nix { };

  # Alternative ICD loader to `ocl-icd` that is in upstream nixpkgs.
  khronos-icd-loader = super.callPackage ./packages/khronos-icd-loader { withDebug = false; };

  # Install 'Plex Pass' version of Plex.
  plexPassRaw = super.unstable.plexRaw.overrideAttrs (old: rec {
    version = "1.16.3.1433-359b06978";
    name = "${old.pname}-${version}";
    src = super.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/redhat/plexmediaserver-${version}.x86_64.rpm";
      sha256 = "03pqr82kgqi6fjy7wwlkbfijbkpfpp2f9rxkw5y4aya3ab7xrzxm";
    };
  });
  plexPass = super.unstable.plex.override { plexRaw = self.plexPassRaw; };

  # Fetch lorri from GitHub.
  lorri = let
    src = super.fetchFromGitHub {
      owner = "target";
      repo = "lorri";
      rev = "094a903d19eb652a79ad6e7db6ad1ee9ad78d26c";
      sha256 = "0y9y7r16ki74fn0xavjva129vwdhqi3djnqbqjwjkn045i4z78c8";
    };
  in super.callPackage src { inherit src; };

  # Fetch nixfmt from GitHub.
  nixfmt = let
    src = super.fetchFromGitHub {
      owner = "serokell";
      repo = "nixfmt";
      rev = "dbed3c31c777899f0273cb6584486028cd0836d8";
      sha256 = "0gsj5ywkncl8rahc8lcij7pw9v9214lk23wspirlva8hwyxl279q";
    };
  in super.callPackage src { installOnly = true; pkgs = self; };

  # Enable hybrid driver on `vaapiIntel`.
  vaapiIntel = super.vaapiIntel.override {
    enableHybridCodec = true;
  };

  # Add a package for ComputeCpp.
  computecpp-unwrapped = super.callPackage ./packages/computecpp.nix { };
  computecpp = ccWrapperFork.wrapCCWith {
    cc = self.computecpp-unwrapped;
    extraCCs = [ "compute" "compute++" ];
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2
