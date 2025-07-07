{ config, pkgs, ... }:

{
  networking.hostName = "NixOS";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";  # or "prohibit-password" for keys only
      passwordAuthentication = true;  # or false if using SSH keys
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
