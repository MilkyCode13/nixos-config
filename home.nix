{ config, pkgs, inputs, ... }:

{
  home.username = "andrey";
  home.homeDirectory = "/home/andrey";

  imports = [
    ./modules/niri.nix
    ./modules/noctalia.nix
    ./modules/firefox.nix
  ];

  home.persistence."/persistent" = {
    directories = [
      "nixos"
      #"Downloads"
      #"Music"
      #"Pictures"
      "Documents"
      #"Videos"
      #"VirtualBox VMs"
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
      #{ directory = ".nixops"; mode = "0700"; }
      #{ directory = ".local/share/keyrings"; mode = "0700"; }
      #".local/share/direnv"
      { directory = ".local/share/TelegramDesktop"; mode = "0700"; }
    ];
    #files = [
    #  ".screenrc"
    #];
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "MilkyCode13";
      email = "shmayhel.andrey@gmail.com";
    };
    signing = {
      format = "openpgp";
      key = "D813B3B251520AA2";
      signByDefault = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.alacritty.enable = true;
  #programs.fuzzel.enable = true;
  #programs.swaylock.enable = true;
  #programs.waybar.enable = true;
  #services.mako.enable = true;
  #services.swayidle.enable = true;
  #services.polkit-gnome.enable = true;

  home.packages = with pkgs; [
    telegram-desktop
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
