{ config, pkgs, lib, ... }:

let
  haImage = pkgs.fetchurl {
    url = "https://github.com/home-assistant/operating-system/releases/download/15.2/haos_ova-15.2.qcow2.xz";
    hash = "sha256-bRgQe/X0GrSRjLJ/u+ztaIwXDoSGkDThPKOObZ1Uckk=";
  };
in {
  systemd.services.hassos-vm = {
    description = "Home Assistant VM";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.libvirt}/bin/virsh define /etc/libvirt/hassos.xml
        ${pkgs.libvirt}/bin/virsh start hassos
      '';
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Add HassOS libvirt XML template to /etc/libvirt
  environment.etc."libvirt/hassos.xml".text = ''
    <domain type='kvm'>
      <name>hassos</name>
      <memory unit='MiB'>2048</memory>
      <vcpu>2</vcpu>
      <os>
        <type arch='x86_64' machine='pc'>hvm</type>
      </os>
      <devices>
        <disk type='file' device='disk'>
          <source file='${haImage}'/>
          <target dev='vda' bus='virtio'/>
        </disk>
        <interface type='network'>
          <source network='default'/>
          <model type='virtio'/>
        </interface>
        <graphics type='vnc' port='-1' autoport='yes'/>
      </devices>
    </domain>
  '';
}
