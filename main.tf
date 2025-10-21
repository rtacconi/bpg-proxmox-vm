# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
resource "proxmox_virtual_environment_vm" "vm" {
  name            = var.name
  vm_id           = var.vm_id
  node_name       = var.node_name
  started         = var.started
  stop_on_destroy = var.stop_on_destroy
  bios            = var.bios
  machine         = var.machine
  scsi_hardware   = "virtio-scsi-single"
  reboot_after_update = var.reboot_after_update
  operating_system {
    type = "l26"
  }

  cpu {
    cores = var.cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.dedicated_memory
  }

  vga {
    type = "qxl"
  }

  tpm_state {
    version = "v2.0"
  }

  efi_disk {
    datastore_id = "local-lvm"
    file_format  = "raw"
    type         = "4m"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address == "dhcp" ? "dhcp" : "${var.ip_address}/${var.netmask}"
        gateway = var.gateway
      }
    }

    dynamic "user_account" {
      for_each = var.ssh_user != null && var.ssh_public_key != null ? [1] : []
      content {
        username = var.ssh_user
        keys     = [trimspace(base64decode(var.ssh_public_key))]
      }
    }

    dynamic "dns" {
      for_each = var.dns_servers != [] ? [1] : []
      content {
        servers = var.dns_servers
        domain  = var.dns_domain
      }
    }
  }

  dynamic "disk" {
    for_each = local.processed_disks
    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      ssd          = disk.value.ssd
      discard      = disk.value.discard
      size         = disk.value.size
      file_format  = disk.value.file_format

      # Include file_id only if it is present
      file_id = try(disk.value.file_id, null)
    }
  }

  dynamic "network_device" {
    for_each = var.network_devices
    content {
      bridge = network_device.value.bridge
    }
  }

  agent {
    enabled = true
    trim    = true
    timeout = "5m"
  }

  keyboard_layout = var.keyboard_layout

  tags = var.tags
}

resource "null_resource" "remove_known_host" {
  depends_on = [proxmox_virtual_environment_vm.vm]
  count      = var.os_family == "talos" ? 0 : 1

  provisioner "local-exec" {
    command = "ssh-keygen -R ${proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]}"
  }
}

# This is used in the place of cloud-init to install qemu-guest-agent
# and to upgrade the packages
resource "null_resource" "install_qemu_guest_agent" {
  depends_on = [null_resource.remove_known_host]
  count      = var.ssh_user != null && var.upgrade && (var.os_family == "debian" || var.os_family == "ubuntu") ? 1 : 0


  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      host    = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]
      user    = var.ssh_user
      agent   = true
      timeout = "2m"
    }

    # returns a script compatible with the Linux family
    inline = [
      var.os_family == "debian" || var.os_family == "ubuntu" ? local.debian : ""
    ]
  }
}

resource "null_resource" "apt_upgrade" {
  depends_on = [null_resource.install_qemu_guest_agent]
  count      = var.ssh_user != null && var.upgrade && (var.os_family == "debian" || var.os_family == "ubuntu") ? 1 : 0

  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      host    = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]
      user    = var.ssh_user
      agent   = true
      timeout = "2m"
    }

    # returns a script compatible with the Linux family
    inline = [
      "sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y",
      "nohup sudo shutdown -r 1",
      "exit 0"

    ]
  }
}
