# This file contains the configuration provided to `nixpkgs.config`. It is imported by NixOS and
# home-manager and placed at `$HOME/.config/nixpkgs/config.nix`.

{
  allowUnfree = true;

  allowBroken = true;

  firefox.enableGnomeExtensions = true;

  pulseaudio = true;

  packageOverrides = pkgs: rec {
    plexPassRaw = pkgs.plexRaw.overrideAttrs (
      old: rec {
        version = "1.18.7.2438-f342a5a43";
        name = "${old.pname}-${version}";
        src = pkgs.fetchurl {
          url = "https://downloads.plex.tv/plex-media-server-new/${version}/redhat/plexmediaserver-${version}.x86_64.rpm";
          sha256 = "07lill29ck5h6lnrxj4k709afh36d6giy4jzv1jwcvcq1hdrvmzh";
        };
      }
    );

    plexPass = pkgs.plex.override { plexRaw = plexPassRaw; };

    vaapiIntel = pkgs.vaapiIntel.override {
      enableHybridCodec = true;
    };
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
