resource "proxmox_vm_qemu" "k3s_master" {
  count         = 1
  name          = "k3s-master"
  target_node   = "pve1"

  clone         = "debian-cloudinit-nfs"

  os_type       = "cloud-init"

  cores         = 2
  sockets       = "1"
  cpu           = "host"
  memory        = 4096
  scsihw        = "virtio-scsi-pci"
  bootdisk      = "virtio0"

  disk {
    size          = "80G"
    type          = "virtio"
    storage       = "nfs"
    iothread      = 1
  }

  network {
    model         = "virtio"
    bridge        = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  #Cloud init-settings
  #ipconfig0       = "ip=192.168.0.150/24,gw=192.168.0.1"

  sshkeys = file(var.ssh_key)

}

resource "proxmox_vm_qemu" "k3s_node" {
  count             = 9
  name              = "k3s-node-${count.index + 1}"
  target_node       = "pve${(count.index % 3) + 1}"

  clone             = "debian-cloudinit-nfs"

  os_type           = "cloud-init"

  cores             = 2
  sockets           = "1"
  cpu               = "host"
  memory            = 3096
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "virtio0"

  disk {
    size            = "80G"
    type            = "virtio"
    storage         = "nfs"
    iothread        = 1
  }

 network {
   model            = "virtio"
   bridge           = "vmbr0"
 }

 lifecycle {
   ignore_changes   = [
     network,
   ]
 }

 #Cloud Init settings
 ipconfig0       = "ip=192.168.0.15${count.index + 1}/24,gw=192.168.0.1"

 sshkeys         = file(var.ssh_key)
}

output "k3s_master_ip" {
  value = proxmox_vm_qemu.k3s_master[0].default_ipv4_address
}