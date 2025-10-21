locals {
  debian = <<EOT
sudo apt-get update

if ! dpkg -l | grep -qw qemu-guest-agent; then 
    sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install qemu-guest-agent;
    sudo sudo systemctl start qemu-guest-agent;
fi
EOT
  processed_disks = [
    for disk in var.disks : merge(
      {
        datastore_id = disk.datastore_id
        interface    = disk.interface
        ssd          = disk.ssd
        discard      = disk.discard
        size         = disk.size
        file_format  = disk.file_format
      },
      disk.file_id != null ? { file_id = disk.file_id } : {}
    )
  ]
}
