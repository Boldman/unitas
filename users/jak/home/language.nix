{ config, pkgs, ... }:

# This file contains the configuration for languages, locales and keyboard layouts.

{
  home = {
    # Use a US keyboard layout.
    keyboard.layout = "us";
    # Set `en_US.utf8` as the locale.
    language.base = "en_US.utf8";
    packages = with pkgs; [ glibcLocales ];
    sessionVariables = {
      "LOCALE_ARCHIVE" = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      "LANGUAGE" = config.home.language.base;
      "LC_ALL" = config.home.language.base;
    };
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
