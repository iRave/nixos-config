{ config, pkgs, ... }:

{
  users.users.irave = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
}
