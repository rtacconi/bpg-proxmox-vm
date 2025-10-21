# Terraform Proxmox VM Module

A Terraform module for creating virtual machines on Proxmox VE using the [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest) provider.

## Features

- Create VMs with customizable CPU, memory, and disk configurations
- Support for multiple operating systems (Debian, Ubuntu, Talos)
- Network configuration with bridge support
- SSH key injection and user account setup
- Cloud-init support for Ubuntu/Debian
- Automatic package updates and qemu-guest-agent installation
- Flexible disk configuration with SSD and discard options

## Usage

### Basic Example

```hcl
module "proxmox_vm" {
  source = "github.com/rtacconi/bpg-proxmox-vm"

  name             = "my-vm"
  node_name        = "proxmox-node"
  cores            = 2
  dedicated_memory = 4096
  environment      = "production"
  tags             = ["web", "production"]
}
```

### Advanced Example with Custom Configuration

```hcl
module "proxmox_vm" {
  source = "github.com/rtacconi/bpg-proxmox-vm"

  name             = "web-server"
  node_name        = "proxmox-node"
  cores            = 4
  dedicated_memory = 8192
  environment      = "production"
  
  # Network configuration
  ip_address = "192.168.1.100"
  netmask    = "24"
  gateway    = "192.168.1.1"
  dns_servers = ["8.8.8.8", "8.8.4.4"]
  
  # Disk configuration
  disks = [
    {
      datastore_id = "local-lvm"
      interface    = "scsi0"
      ssd          = true
      discard      = "on"
      size         = 50
      file_format = "raw"
    }
  ]
  
  # SSH configuration
  ssh_user        = "admin"
  ssh_public_key  = base64encode(file("~/.ssh/id_rsa.pub"))
  
  tags = ["web", "production", "nginx"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8.5 |
| proxmox | ~> 0.0 |

## Providers

| Name | Version |
|------|---------|
| proxmox | ~> 0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |
| [null_resource.remove_known_host](https://registry.terraform.io/docs/providers/null/r/resource.html) | resource |
| [null_resource.install_qemu_guest_agent](https://registry.terraform.io/docs/providers/null/r/resource.html) | resource |
| [null_resource.apt_upgrade](https://registry.terraform.io/docs/providers/null/r/resource.html) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the VM | `string` | n/a | yes |
| node_name | The name of the node where you want to create the VM | `string` | n/a | yes |
| environment | The environment name | `string` | n/a | yes |
| cores | Number of cores | `number` | `1` | no |
| dedicated_memory | RAM in KiB | `number` | `1024` | no |
| cpu_type | CPU type (Talos needs kvm64 but usually it's host) | `string` | `"host"` | no |
| started | Start the VM or not | `bool` | `true` | no |
| stop_on_destroy | Stop on destroy | `bool` | `true` | no |
| ip_address | IP address | `string` | `"dhcp"` | no |
| netmask | Netmask, example: 24 | `string` | `null` | no |
| gateway | Default gateway | `string` | `null` | no |
| dns_servers | List of DNS servers | `list(any)` | `[]` | no |
| dns_domain | DNS config map | `string` | `""` | no |
| network_devices | List of network device configurations | `list(object({bridge = string}))` | `[{"bridge": "vmbr11"}]` | no |
| disks | List of disks to attach to the VM | `list(object({datastore_id = string, interface = string, ssd = bool, discard = string, size = number, file_format = string, file_id = optional(string)}))` | `[]` | no |
| os_family | State the family of the OS, at the moment only debian/ubuntu/talos | `string` | n/a | yes |
| ssh_user | The user name | `string` | `null` | no |
| ssh_public_key | The public key to be copied in the new VM | `string` | `null` | no |
| upgrade | Upgrade the VM | `string` | `false` | no |
| tags | Tags | `list(string)` | n/a | yes |
| vm_id | VM ID number | `number` | `null` | no |
| bios | The BIOS implementation (defaults to seabios) | `string` | `"ovmf"` | no |
| machine | The VM machine type (defaults to pc) | `string` | `"q35"` | no |
| scsi_hardware | The SCSI hardware type (defaults to virtio-scsi-pci) | `string` | `"virtio-scsi-pci"` | no |
| keyboard_layout | The keyboard layout (defaults to en-us) | `string` | `"en-us"` | no |
| reboot_after_update | Reboot after update | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| vm | The created Proxmox VM resource |
| name | The name of the VM |
| ssh_user | The SSH user configured for the VM |

## Examples

See the [examples](./examples/) directory for complete working examples.

### Cluster Example

The examples directory contains a complete cluster setup example that demonstrates:

- Creating multiple VMs across different Proxmox nodes
- Using Ubuntu cloud images
- Configuring networking and storage
- Setting up a complete cluster environment

## License

This module is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please use the [GitHub Issues](https://github.com/rtacconi/bpg-proxmox-vm/issues) page.