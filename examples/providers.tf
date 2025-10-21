# Provider configuration for Proxmox
terraform {
  required_version = "> 1.8.5"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.0"
    }
  }
}

# Default provider configuration
provider "proxmox" {
  # Add your Proxmox configuration here
  # endpoint = "https://your-proxmox-server:8006/api2/json"
  # username  = "your-username@pam"
  # password  = "your-password"
  # insecure  = true
}

# Provider alias for he1 node
provider "proxmox" {
  alias = "he1"
  # Add specific configuration for he1 node if needed
  # endpoint = "https://he1:8006/api2/json"
  # username  = "your-username@pam"
  # password  = "your-password"
  # insecure  = true
}
