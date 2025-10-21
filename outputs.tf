output "vm" {
  value = proxmox_virtual_environment_vm.vm
}

output "name" {
  value = var.name
}

output "ssh_user" {
  value = var.ssh_user
}