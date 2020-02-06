# Software and Hardware I use

## Software

When I look for software I tend to look for programs that are open and minimalistic
as well being easily managed through [Home-manager][] created by [rycee][].

<h3><img width="50" alt="Nix logo" src="https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/x207px-Home-nixos-logo.png.pagespeed.ic.38jujIAhx5.png">Nix</h3>

[Nix][] is a powerful package manager for Linux and other Unix systems that makes package management reliable and reproducible.
It provides atomic upgrades and rollbacks, side-by-side installation of multiple versions of a package, multi-user package management and easy setup of build environments.


<h3><img width="50" alt="NixOS 19.09 Logo" src= https://raw.githubusercontent.com/NixOS/nixos-artwork/master/releases/19.09-loris/loris.png>NixOS 19.09 "loris"</h3>

[NixOS][] is a Linux distribution with a unique approach to package and configuration management.
Built on top of the Nix package manager, it is completely declarative, makes upgrading systems reliable, and has many other advantages.


#### NixOps
[NixOps][] is a deployment tool, both for cloud and NixOS machines.

#### Niv
[Niv][] is an easy dependency manager for Nix based projects.
It allows me to pin versions of packages from git commits, like vim plugins.

#### Lorri
[lorri][] is a `nix-shell` replacement for project development. lorri is
based around fast direnv integration for robust CLI and editor
integration.


<h4><img width="150" alt="i3wm logo" src="https://raw.githubusercontent.com/i3/i3.github.io/master/img/logo.png"></h4>

[i3][] a tiling window manager, configured in text so easily managed by Home-Manager.

<h3><img width="50" alt="Alacritty Logo" src="https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/compat/alacritty-term%2Bscanlines.png">Alacritty</h3>

[Alacritty][] is a terminal emulator with a strong focus on simplicity and performance.
With such a strong focus on performance, included features are carefully considered and you can always expect Alacritty to be blazingly fast.
By making sane choices for defaults, Alacritty requires no additional setup.
However, it does allow configuration of many aspects of the terminal through Home-Manager.

<h3><img width="150" alt="Neovim logo" src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/images/logo%402x.png"></h3>

<h3><img width="150" alt="Rofi Logo" src="https://cdn.slant.co/d6008a78-ea3b-4c11-9f31-760fd7353445/-/format/jpeg/-/progressive/yes/-/preview/480x480/"></h3>

<h3><img width="150" alt="Firefox logo" src="https://www.mozilla.org/media/protocol/img/logos/firefox/browser/logo-word-hor-sm.5622edbdf02d.png"></h3>

<h3><img width="50" alt="MPD logo" src="https://raw.githubusercontent.com/MusicPlayerDaemon/website/master/content/logo.png">Music Player Daemon</h3>

<h3><img width="50" alt="mpv logo" src="https://raw.githubusercontent.com/mpv-player/mpv.io/master/source/images/mpv-logo-128.png">mpv</h3>



## Wishlist

<h3><img width="50" alt="newsboat logo" src="https://newsboat.org/logo.svg">Newsboat</h3>
Would like to manage rss feeds on my machine rather than just on my phone.

<h3><img width="50" alt="mutt logo" src="https://raw.githubusercontent.com/neomutt/neomutt.github.io/master/images/mutt-64x64.png">NeoMutt</h3>
I want to setup local inbox, but not priority right now.

#### Disnix
Nix based service deployment, want to use this to deploy services while using Nixops for infrastructure

#### Hydra
I want to deploy are person build farm using this but for now I'm using [Hercules][]

[Home-Manager]: https://github.com/rycee/home-manager
[rycee]: https://rycee.net/
[Nix]: https://nixos.org/nix/about.html
[Nixos]: https://nixos.org/nixos/about.html
[Nixops]: https://nixos.org/nixops/
[Niv]: https://github.com/nmattia/niv
[lorri]: https://github.com/target/lorri
[Hercules]: https://hercules-ci.com
[Alacritty]: https://github.com/alacritty/alacritty
