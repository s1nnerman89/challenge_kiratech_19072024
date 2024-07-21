# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {

    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            # New provider to use until the telmate one gets adapted for proxmox > 8.1
            source = "TheGameProfi/proxmox"
            version = "2.9.16"
        }
    }
}

variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "ansible_user_password" {
    type = string
    sensitive = true
}

variable "pve_user" {
    type = string
}

variable "pve_host" {
    type = string
}

provider "proxmox" {

    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
    #pm_debug = true # DISABLE IN PROD

}
