{
  description = ''
    Veritas is the declarative configuration of David Wood's servers, desktops and laptops, as
    well as a collection of packages.
  '';

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs-channels";
      ref = "nixpkgs-unstable";
    };

    home-manager = {
      type = "github";
      owner = "rycee";
      repo = "home-manager";
      ref = "bqv-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @ inputs:
    with inputs.nixpkgs.lib;
    let
      # Define the systems that are supported by this flake (e.g. used by some NixOS
      # configurations).
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = genAttrs systems;

      # Import nixpkgs for a given system with this repository's config and overlays.
      mkNixpkgs = system:
        import inputs.nixpkgs {
          inherit system;
          config = import ./nix/config.nix;
          overlays = self.internal.overlays."${system}";
        };

      # Import nixpkgs for each supported system.
      pkgsBySystem = forEachSystem mkNixpkgs;

      # Define a NixOS configuration with a name and config path (for a specific system).
      mkNixOsConfiguration = name: { system, config }:
        nameValuePair name (nixosSystem {
          inherit system;
          modules = [
            ({ name, ... }: {
              # Set the hostname to the name of the configuration being applied (since the
              # configuration being applied is determined by the hostname).
              networking.hostName = name;
            })
            ({ inputs, ... }: {
              # Use the nixpkgs from the flake.
              nixpkgs = { pkgs = pkgsBySystem."${system}"; };

              # For compatibility with nix-shell, nix-build, etc.
              environment.etc.nixpkgs.source = inputs.nixpkgs;
              nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
            })
            ({ pkgs, ... }: {
              # Don't rely on the configuration to enable a flake-compatible version of Nix.
              nix = {
                package = pkgs.nixFlakes;
                extraOptions = "experimental-features = nix-command flakes";
              };
            })
            ({ inputs, ... }: {
              # Re-expose self and nixpkgs as flakes.
              nix.registry = {
                self.flake = inputs.self;
                nixpkgs = {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  flake = inputs.nixpkgs;
                };
              };
            })
            (import ./nixos/configs)
            (import ./nixos/modules)
            (import ./nixos/profiles)
            (import config)
          ];
          specialArgs = { inherit name inputs; };
        });

      # Define the home-manager configuration for a host (for use as both input to the NixOS
      # home-manager module; and to the `homeManagerConfiguration` function).
      mkHomeManagerConfiguration = name: { system, config }:
        nameValuePair name ({ ... }: {
          imports = [
            (import ./home/configs)
            (import ./home/modules)
            (import ./home/profiles)
            (import config)
          ];

          # For compatibility with nix-shell, nix-build, etc.
          home.file.".nixpkgs".source = inputs.nixpkgs;
          systemd.user.sessionVariables."NIX_PATH" =
            mkForce "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

          # Use the same Nix configuration throughout the system.
          xdg.configFile."nixpkgs/config.nix".source = ./nix/config.nix;

          # Re-expose self and nixpkgs as flakes.
          xdg.configFile."nix/registry.json".text = builtins.toJSON {
            version = 2;
            flakes =
              let
                toInput = input:
                  {
                    type = "path";
                    path = input.outPath;
                  } // (
                    filterAttrs
                      (n: _: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
                      input
                  );
              in
              [
                {
                  from = { id = "self"; type = "indirect"; };
                  to = toInput inputs.self;
                }
                {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  to = toInput inputs.nixpkgs;
                }
              ];
          };
        });

      # Define a home-manager configuration for a host.
      mkHomeManagerHostConfiguration = name: { system }:
        nameValuePair name (inputs.home-manager.lib.homeManagerConfiguration {
          inherit system;
          configuration = { ... }: {
            imports = [ self.internal.homeManagerConfigurations."${name}" ];

            nixpkgs = {
              config = import ./nix/config.nix;
              overlays = self.internal.overlays."${system}";
            };
          };
          homeDirectory = "/home/david";
          pkgs = pkgsBySystem."${system}";
          username = "david";
        });

      # Define the packages exposed by this flake for a system.
      mkPackages = system:
        let
          pkgs = pkgsBySystem."${system}";
        in
        {
          rustfilt = pkgs.callPackage ./nix/packages/rustfilt.nix { };
          workman = pkgs.callPackage ./nix/packages/workman.nix { };
        }
        // (
          optionalAttrs (system == "x86_64-linux") {
            intel-openclrt = pkgs.callPackage ./nix/packages/intel-openclrt.nix { };
          }
        );
    in
    {
      # Create the NixOS configurations for each host.
      nixosConfigurations = mapAttrs' mkNixOsConfiguration {
        dtw-campaglia = { system = "x86_64-linux"; config = ./nixos/hosts/campaglia.nix; };

        dtw-jar-keurog = { system = "x86_64-linux"; config = ./nixos/hosts/jar-keurog.nix; };

        dtw-volkov = { system = "x86_64-linux"; config = ./nixos/hosts/volkov.nix; };
      };

      # Create the home-manager configurations for each host.
      internal = {
        homeManagerConfigurations = mapAttrs' mkHomeManagerConfiguration {
          dtw-campaglia = { system = "x86_64-linux"; config = ./home/hosts/campaglia.nix; };

          dtw-jar-keurog = { system = "x86_64-linux"; config = ./home/hosts/jar-keurog.nix; };

          dtw-volkov = { system = "x86_64-linux"; config = ./home/hosts/volkov.nix; };
        };

        # Overlays consumed by the home-manager/NixOS configuration.
        overlays = forEachSystem (system: [
          (self.overlay."${system}")
          (import ./nix/overlays/vaapi.nix)
        ] ++ optionals (system == "x86_64-linux") [
          (import ./nix/overlays/plex.nix)
        ]);
      };

      # Create the evaluated home-manager configurations for each home-manager-only host.
      homeManagerConfigurations = mapAttrs' mkHomeManagerHostConfiguration { };

      # Create the package set for each system.
      packages = forEachSystem mkPackages;

      # Expose the development shells defined in the repository, run these with:
      #
      #   nix dev-shell 'self#devShells.x86_64-linux.rustc'
      devShells = forEachSystem (system:
        let
          pkgs = pkgsBySystem."${system}";
        in
        {
          llvm-clang = import ./nix/shells/llvm-clang.nix { inherit pkgs; };
          rustc = import ./nix/shells/rustc.nix { inherit pkgs; };
        }
      );

      # Import the modules exported by this flake. Explicitly don't expose profiles in
      # `nixos/configs` and `nixos/profiles` - these are only used for internal organization
      # of my configurations.
      #
      # These are only used by other projects that might import this flake.
      nixosModules = {
        perUserVpn = import ./nixos/modules/per-user-vpn.nix;
      };

      # Expose an overlay which provides the packages defined by this repository - overlays
      # are used more widely in this repository, but often for modifying upstream packages
      # or making third-party packages easier to access - it doesn't make sense to share those,
      # so they in the flake output `internal.overlays`.
      overlay = forEachSystem (system: _: _: self.packages."${system}");
    };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
