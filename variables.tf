variable "ssh_user" {
  description = "The user name"
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "The public key to be copied in the new VM"
  type        = string
  default     = null
}

variable "cpu_type" {
  description = "Talos needs kvm64 but usually it's host"
  type        = string
  default     = "host"
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "started" {
  description = "Start the VM or not"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags"
  type        = list(string)
}

variable "ip_address" {
  description = "IP address"
  type        = string
  default     = "dhcp"
}

variable "netmask" {
  description = "Netmask, example: 24"
  type        = string
  default     = null
}

variable "gateway" {
  description = "Default gateway"
  type        = string
  default     = null
}

variable "dns_domain" {
  description = "DNS config map"
  type        = string
  default     = ""
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(any)
  default     = []
}

variable "network_devices" {
  description = "List of network device configurations"
  type = list(object({
    bridge = string
  }))
  default = [
    {
      bridge = "vmbr11"
    }
  ]
}

variable "vm_id" {
  description = "VM ID number"
  type        = number
  default     = null
}

variable "node_name" {
  description = "The name of the node where you want to create the VM"
  type        = string
}

variable "name" {
  description = "Name of the VM"
}

variable "dedicated_memory" {
  description = "RAM in KiB"
  type        = number
  default     = 1024
}

variable "cores" {
  description = "Number of cores"
  type        = number
  default     = 1
}

variable "disks" {
  description = "List of disks to attach to the VM"
  type = list(object({
    datastore_id = string
    interface    = string
    ssd          = bool
    discard      = string
    size         = number
    file_format  = string
    file_id      = optional(string)
  }))
  default = []
}

variable "os_family" {
  description = "State the family of the OS, at the moment only debian/ubuntu"
  type        = string

  validation {
    condition     = contains(["debian", "ubuntu", "talos"], var.os_family)
    error_message = "The os_family variable must be either 'debian' or 'ubuntu'."
  }
}

variable "upgrade" {
  description = "Upgrade the VM"
  type        = string
  default     = false
}

variable "stop_on_destroy" {
  description = "Stop on destroy"
  type        = bool
  default     = true
}

variable "operating_system_type" {
  description = "The Operating System configuration: type. The type (defaults to other)"
  type        = string
  default     = "other"
}

variable "bios" {
  description = "The BIOS implementation (defaults to seabios)"
  type        = string
  default     = "ovmf"
}

variable "machine" {
  description = "The VM machine type (defaults to pc)"
  type        = string
  default     = "q35"
}

variable "scsi_hardware" {
  description = "The SCSI hardware type (defaults to virtio-scsi-pci)"
  type        = string
  default     = "virtio-scsi-pci"
}

variable "keyboard_layout" {
  description = "The keyboard layout (defaults to en-us)"
  type        = string
  default     = "en-us"
}

variable "reboot_after_update" {
  description = "Reboot after update"
  type = bool
  default = false
}