{ config, pkgs, ... }:

{
  users.users.irave = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
}
