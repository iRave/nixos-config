{ lib, config, pkgs, ... }:

{
  imports = [];
  
  networking.hostName = lib.mkForce "nixos-microserver";
  
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [
    wget
    git
    qemu
    virt-manager
    inputs.compose2nix.packages.x86_64-linux.default
  ];

  system.stateVersion = "25.05";
}
