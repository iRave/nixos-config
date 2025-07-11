{ lib, config, pkgs, ... }:

{
  imports = [];

  networking.hostName = lib.mkForce "nixos-microserver";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
   environment.systemPackages = with pkgs; [
    wget
    git
    qemu
    virt-manager
    compose2nix
    neovim
    btop
  ];

  system.stateVersion = "25.05";
}