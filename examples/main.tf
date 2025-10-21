module "nodes" {
  source           = "../modules/proxmox_vm"
  for_each         = { for idx, node in var.cluster.nodes : idx => node }
  environment      = "dev"
  cores            = 2
  dedicated_memory = 4096
  name             = "${var.cluster.cluster_name}-n${each.key}"
  node_name        = each.value.node
  scsi_hardware    = "virtio-scsi-single"
  ip_address       = "dhcp"
  dns_servers      = var.dns_servers
  os_family        = "ubuntu"
  disks = [
    {
      datastore_id = "local-lvm"
      interface    = "scsi0"
      ssd          = true
      discard      = "on"
      size         = 40
      file_format  = "raw"
      file_id      = proxmox_virtual_environment_file.ubuntu_jammy[each.value.node].id
    }
  ]
  network_devices = [
    {
      bridge = var.bridge
    }
  ]
  tags = [var.cluster.cluster_name, "node"]
}

# Upload Ubuntu image to each node
resource "proxmox_virtual_environment_file" "ubuntu_jammy" {
  for_each = { for node in var.cluster.nodes : node.node => node }
  
  timeout_upload = 2800
  datastore_id   = "local"
  node_name      = each.value.node
  content_type   = "iso"
  source_file {
    path      = "/tmp/jammy-server-cloudimg-amd64.img"
    file_name = "jammy-server-cloudimg-amd64.img"
  }
}