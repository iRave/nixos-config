{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = false;
  users.groups.docker.members = [ "irave" ];
}
