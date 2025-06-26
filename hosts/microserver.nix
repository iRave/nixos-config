{ config, pkgs, ... }:

{
  imports = [];
  
  networking.hostName = "nixos-microserver";
  
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [
    wget
    git
    qemu
    virt-manager
  ];

  system.stateVersion = "25.05";
}
