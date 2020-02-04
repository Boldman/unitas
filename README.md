# Unitas
This repo in my personal [monorepo][] containing my machine and user configurations.
This project in managed by a [Nix][] based tool-chain and inspired by [Veritas][] made by davidtwco.

# Structure
The structure of this repository is described below:

Path                        | Description
----                        | -------------
`./hosts`                   | top-level expressions specific to individual machines
`./packages`                | custom packages
`./profiles`                | common configurations shared between hosts
`./modules`                 | re-usable configuration modules
`./nix`                     | [niv][] managed dependencies and `nixpkgs.config`
`./shells`                  | contains development shells
`./users/jak/default.nix`   | module that creates user `jak` and instantiates home-manager config
`./users/jak/home`          | home-manager configuration and dotfiles

#Author
This project is developed by Jacob Boldman.


[monorepo]: https://en.wikipedia.org/wiki/Monorepo
[Nix]: https://nixos.org/nix
[Niv]: https://github.com/nmattia/niv
[Veritas]: https://github.com/davidtwco/veritas
