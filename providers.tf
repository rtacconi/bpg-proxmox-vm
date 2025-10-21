# see https://github.com/hashicorp/terraform
terraform {
  required_version = "> 1.8.5"
  required_providers {
    # see https://registry.terraform.io/providers/bpg/proxmox
    # see https://github.com/bpg/terraform-provider-proxmox
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}