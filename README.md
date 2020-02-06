# Unitas

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

This repo in my personal [monorepo][] containing my machine and user configurations.
This project in managed by a [Nix][] based tool-chain.

Inspired by [Veritas][] made by davidtwco and [Luke Smith][]'s [voidrice][] and [LARBS][].

# Structure
The structure of this repository is described below:

| Path                      | Description                                                         |
|---------------------------|---------------------------------------------------------------------|
| `./bin`                   | random scripts not worth packaging                                  |
| `./deployments`           | network modules manged by Nixops                                    |
| `./hosts`                 | top-level expressions specific to individual machines               |
| `./modules`               | re-usable configuration modules                                     |
| `./nix`                   | [Niv][] managed dependencies and `nixpkgs.config`                   |
| `./pkgs`                  | custom packages                                                     |
| `./profiles`              | common configurations shared between hosts                          |
| `./shells`                | contains development shells                                         |
| `./users/jak/default.nix` | module that creates user `jak` and instantiates home-manager config |
| `./users/jak/home`        | home-manager configuration and dotfiles                             |
| `./wiki`                  | folder containing wiki pages                                        |



# Author
This project is developed by Jacob Boldman.


[monorepo]: https://en.wikipedia.org/wiki/Monorepo
[Nix]: https://nixos.org/nix
[Niv]: https://github.com/nmattia/niv
[Veritas]: https://github.com/davidtwco/veritas
[voidrice]: https://github.com/LukeSmithxyz/voidrice
[LARBS]: https://github.com/LukeSmithxyz/LARBS
[Luke Smith]: https://lukesmith.xyz
