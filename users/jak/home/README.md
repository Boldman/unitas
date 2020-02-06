# Software and Hardware I use

## Software

When I look for software I tend to look for programs that are open and minimalistic
as well being easily managed through [Home-manager][] created by [rycee][].

### Nix Ecosystem


<p align="left">
    <img width="100" alt="Nix Logo" src="https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/x207px-Home-nixos-logo.png.pagespeed.ic.38jujIAhx5.png">
</p>
<h3 align="left">Nix</h3>

[Nix][] is a powerful package manager for Linux and other Unix systems that makes package management reliable and reproducible.
It provides atomic upgrades and rollbacks, side-by-side installation of multiple versions of a package, multi-user package management and easy setup of build environments.

<p align="left">
    <img width="100" alt="NixOS 19.09 Logo" src= https://raw.githubusercontent.com/NixOS/nixos-artwork/master/releases/19.09-loris/loris.png>
</p>
<h3 align="left">NixOS</h3>

[NixOS][] is a Linux distribution with a unique approach to package and configuration management.
Built on top of the Nix package manager, it is completely declarative, makes upgrading systems reliable, and has many other advantages.

#### Nixops
[Nixops][] is a deployment tool, both for cloud and NixOS machines.

#### Niv
[Niv][] is an easy dependency manager for Nix based projects.
It allows me to pin versions of packages from git commits, like vim plugins.

#### Lorri
[lorri][] is a `nix-shell` replacement for project development. lorri is
based around fast direnv integration for robust CLI and editor
integration.

<p align="left">
    <img width="100" alt="Alacritty Logo" src="https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/compat/alacritty-term%2Bscanlines.png">
</p>
<h3 align="left">Alacritty</h3>

[Alacritty][] is a terminal emulator with a strong focus on simplicity and performance.
With such a strong focus on performance, included features are carefully considered and you can always expect Alacritty to be blazingly fast.
By making sane choices for defaults, Alacritty requires no additional setup.
However, it does allow configuration of many aspects of the terminal through Home-Manager.

### Window Manager
[i3][] a tiling window manager, configured in text so easily managed by Home-Manager.

### Text Editor
[Neovim

### Web Browser

### Music

### Video



### Wishlist

## Newsboat
Would like to manage rss feeds on my machine rather than just on my phone.


## Disnix
Nix based service deployment, want to use this to deploy services while using Nixops for infrastructure

## Hydra
I want to deploy are person build farm using this but for now I'm using [Hercules][]

## Mutt/Neomutt
I want to set this up eventually, but not a priority right now

[Home-Manager]: https://github.com/rycee/home-manager
[rycee]: https://rycee.net/
[Nix]: https://nixos.org/nix/about.html
[Nixos]: https://nixos.org/nixos/about.html
[Nixops]: https://nixos.org/nixops/
[Niv]: https://github.com/nmattia/niv
[lorri]: https://github.com/target/lorri
[Hercules]: https://hercules-ci.com
[Alacritty]: https://github.com/alacritty/alacritty
