{ config, pkgs, ... }:

{
  home.username = "irave";
  home.homeDirectory = "/home/irave";

  home.stateVersion = "25.05";

  programs.git.enable = true;
  programs.zsh.enable = true;
  programs.starship.enable = true;

  home.packages = with pkgs; [
    neovim
    curl
    wget
    htop
  ];

}
