{ config, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  # Automatically optimise the Nix store.
  nix.autoOptimiseStore = true;

  # Import various configurations for the system.
  imports = [ ./hardware.nix ];

  nixpkgs.config = {
    allowUnfree = true;

    firefox.enableGnomeExtensions = true;

    packageOverrides = pkgs: rec {
      # Enable i3 support for polybar.
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };

  # Audio {{{
  # =====
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
  };
  # }}}

  # i18n {{{
  # ====
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  time.timeZone = "Europe/London";
  # }}}

  # Packages {{{
  # ========
  environment.systemPackages = with pkgs; [
    # General utilities
    wget file unzip zip unrar p7zip dmidecode pstree dtrx htop iotop powertop ltrace strace
    linuxPackages.perf pciutils lshw smartmontools usbutils inetutils wireshark
    nix-prefetch-scripts pmutils psmisc which binutils bc exfat dosfstools patchutils moreutils
    ncdu bmon nix-index exa neofetch mosh pkgconfig

    # Desktop utilities
    scrot xsel xlibs.xbacklight arandr pavucontrol paprefs xclip gnome3.gnome-tweaks hsetroot
    i3lock-fancy plotinus chrome-gnome-shell gnomeExtensions.dash-to-dock
    gnomeExtensions.topicons-plus gnomeExtensions.appindicator

    # Man pages
    man man-pages posix_man_pages stdman

    # Dotfiles
    yadm antibody polybar rofi fasd compton pinentry_ncurses

    # Version control
    git gnupg mercurial bazaar subversion git-lfs

    # Development environment
    vim tmux ctags alacritty rustup ripgrep silver-searcher neovim tmate

    # Ruby
    jekyll ruby rubocop travis doxygen

    # Python
    pipenv jetbrains.pycharm-community pypy pythonFull python2Full python3Full
    python27Packages.virtualenv python36Packages.virtualenv

    # C/C++
    valgrind gdb rr llvmPackages.libclang patchelf ccache gcc cmake llvm gnumake autoconf nasm
    automake ninja libcxxabi libcxx clang-tools cquery clang clang_7 spirv-tools opencl-headers
    opencl-info ocl-icd

    # Node
    nodejs

    # Misc. developer tools
    graphviz python36Packages.xdot

    # Browser
    firefox

    # Chat apps
    tdesktop weechat slack discord hipchat riot-web signal-desktop mumble_git

    # Keybase
    keybase kbfs keybase-gui

    # Desktop themes
    arc-icon-theme arc-kde-theme arc-theme

    # Academic
    git-latexdiff proselint pandoc

    # Hardware
    solaar ltunify steamcontroller
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    meslo-lg source-code-pro source-sans-pro source-serif-pro font-awesome_5 inconsolata
    siji material-icons powerline-fonts roboto roboto-mono roboto-slab iosevka
  ];

  programs = {
    # Cache compilation.
    ccache.enable = true;

    # Change light from terminal.
    light.enable = true;

    # Add Ctrl+Shift+P menus to applications.
    plotinus.enable = true;

    # Enable connections via mosh.
    mosh = {
      enable = true;
      withUtempter = true;
    };

    # Syntax highlight within nano.
    nano.syntaxHighlight = true;

    # Use zsh as the shell.
    zsh.enable = true;
  };


  # Clean temporary directory.
  boot.cleanTmpDir = true;

  services = {
    # Enable user services.
    dbus.socketActivated = true;

    # Enable locate to find files quickly.
    locate.enable = true;

    # Enable CUPS for printing.
    printing.enable = true;

    # Start an ssh server.
    openssh = {
      enable = true;
      forwardX11 = true;
      openFirewall = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    udev.packages = with pkgs; [
      # Required for android devices in `/dev` to have correct access levels.
      android-udev-rules
    ];
  };

  # Use libvirtd to manage virtual machines.
  virtualisation.libvirtd.enable = true;

  # Enable docker.
  virtualisation.docker.enable = true;
  # }}}

  # X Server {{{
  # ========
  services.xserver = {
    enable = true;
    layout = "gb";

    desktopManager = {
      gnome3.enable = true;
      wallpaper.mode = "center";
    };
  };

  services.gnome3.chrome-gnome-shell.enable = true;

  environment.etc."xdg/Trolltech.conf" = {
    text = ''
      [Qt]
      style=GTK+
    '';
    mode = "444";
  };

  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-icon-theme-name="Arc"
      gtk-theme-name="Arc-Darker"
    '';
    mode = "444";
  };
  # }}}

  # Users {{{
  # =====
  users.extraUsers.david = {
    description = "David Wood";
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword = "$6$kvMx6lEzQPhkSj8E$KfP/qM2cMz5VqNszLjeOBGnny3PdIyy0vnHzIgP.gb1XqTI/qq3nbt0Qg871pkmwJwIu3ZGt57yShMjFFMR3x1";
  };

  # Do not allow users to be added or modified except through Nix configuration.
  users.mutableUsers = false;
  # }}}
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2
