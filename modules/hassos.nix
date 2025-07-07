{ config, pkgs, lib, ... }:

let
  haCompressed = pkgs.fetchurl {
    url = "https://github.com/home-assistant/operating-system/releases/download/15.2/haos_ova-15.2.qcow2.xz";
    hash = "sha256-bRgQe/X0GrSRjLJ/u+ztaIwXDoSGkDThPKOObZ1Uckk=";
  };

  # Destination path for the unpacked image
  imagePath = "/var/lib/libvirt/images/hassos.qcow2";
in {
  # Ensure libvirt directory exists
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/images 0755 libvirt-qemu kvm -"
  ];

  # Unpack & stage the image at activation time
  system.activationScripts.hassosImage = {
    description = "Unpack and stage HassOS QCOW2 image";
    text = ''
      if [ ! -f "${imagePath}" ]; then
        echo "Unpacking Home Assistant image..."
        mkdir -p /var/lib/libvirt/images
        cp ${haCompressed} /tmp/hassos.qcow2.xz
        unxz /tmp/hassos.qcow2.xz
        mv /tmp/hassos.qcow2 ${imagePath}
        chown libvirt-qemu:kvm ${imagePath}
        chmod 644 ${imagePath}
      else
        echo "HassOS image already present."
      fi
    '';
  };

  # Auto-define and start the VM
  systemd.services.hassos-vm = {
    description = "Home Assistant OS VM";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        ${pkgs.libvirt}/bin/virsh undefine hassos || true
        ${pkgs.libvirt}/bin/virsh define /etc/libvirt/hassos.xml
        ${pkgs.libvirt}/bin/virsh start hassos
      '';
    };
  };

  # Define the VM via libvirt XML (stored in Nix)
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
          <driver name='qemu' type='qcow2'/>
          <source file='${imagePath}'/>
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
