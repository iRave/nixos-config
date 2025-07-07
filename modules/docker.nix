{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

#  let 
#    dockgeComposeFile = pkgs.writeText "dockge-compose.yml" ''
#      version: "3.8"
#  
#      services:
#        dockge:
#          image: louislam/dockge:latest
#          container_name: dockge
#          restart: unless-stopped
#          ports:
#            - "5001:5001"
#          volumes:
#            - /var/lib/dockge/config:/app/data
#            - /var/lib/dockge/stacks:/app/stacks
#            - /var/run/docker.sock:/var/run/docker.sock
#    '';
#  in
#  {
#    environment.systemPackages = with pkgs; [ docker-compose ]; # optional if using CLI
#  
#    systemd.services.dockge = {
#      description = "Dockge Docker Compose Manager";
#      after = [ "docker.service" ];
#      requires = [ "docker.service" ];
#      wantedBy = [ "multi-user.target" ];
#  
#      serviceConfig = {
#        ExecStart = "${pkgs.docker}/bin/docker compose -f ${dockgeComposeFile} up";
#        ExecStop = "${pkgs.docker}/bin/docker compose -f ${dockgeComposeFile} down";
#        WorkingDirectory = "/var/lib/dockge";
#        Restart = "always";
#      };
#  
#      path = [ pkgs.docker ];
#    };
#  
#    # Create required folders
#    systemd.tmpfiles.rules = [
#      "d /var/lib/dockge/config 0755 root root"
#      "d /var/lib/dockge/stacks 0755 root root"
#    ];
#  }
}

