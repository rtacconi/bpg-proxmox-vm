# Upload Ubuntu image to Proxmox
resource "proxmox_virtual_environment_file" "ubuntu_jammy" {
  timeout_upload = 2800
  datastore_id   = "local"
  node_name      = "proxmox-node"
  content_type   = "iso"
  source_file {
    path      = "/tmp/jammy-server-cloudimg-amd64.img"
    file_name = "jammy-server-cloudimg-amd64.img"
  }
}

# Simple example of using the bpg-proxmox-vm module
module "proxmox_vm" {
  source = "github.com/rtacconi/bpg-proxmox-vm"

  name             = "example-vm"
  node_name        = "proxmox-node"
  cores            = 2
  dedicated_memory = 4096
  environment      = "development"
  os_family        = "ubuntu"
  tags             = ["example", "development"]
  
  # Optional: SSH configuration
  ssh_user        = "ubuntu"
  ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC..."
  
  # Optional: Network configuration
  ip_address = "dhcp"
  dns_servers = ["8.8.8.8", "8.8.4.4"]
  
  # Disk configuration with Ubuntu image
  disks = [
    {
      datastore_id = "local-lvm"
      interface    = "scsi0"
      ssd          = true
      discard      = "on"
      size         = 20
      file_format  = "raw"
      file_id      = proxmox_virtual_environment_file.ubuntu_jammy.id
    }
  ]
}

# Output the VM information
output "vm_id" {
  value = module.proxmox_vm.vm.id
}

output "vm_name" {
  value = module.proxmox_vm.name
}
