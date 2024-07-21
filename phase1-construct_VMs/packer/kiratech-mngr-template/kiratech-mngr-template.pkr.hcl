# Ubuntu Server jammy
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox

# Specify plugin to use - Needed since Packer 1.7
packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.7"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variable Definitions

variable "proxmox_api_url" {
    type = string
    description = "Proxmox API URL"
}

variable "proxmox_api_token_id" {
    type = string
    description = "Proxmox API Token ID"
}

variable "proxmox_api_token_secret" {
    type = string
    description = "Proxmox API Token Secret"
    sensitive = true
}

variable "ansible_user_password" {
    type = string
    description = "Ansible User Password"
    sensitive = true
}

# Resource Definiation for the VM Template
source "proxmox-iso" "kiratech-mngr-template" {
 
    # Proxmox Connection Settings
    proxmox_url = var.proxmox_api_url
    username = var.proxmox_api_token_id
    token = var.proxmox_api_token_secret
    
    # VM General Settings
    node = "<REDACTED>"
    vm_id = "950"
    vm_name = "kiratech-mngr-template"
    template_description = "Ubuntu Server VM - 22.04.03 - EFI - Kubernetes Manager - Template generated with packer"
    tags = "template"
    machine = "q35"
    bios = "ovmf"

    # VM OS Settings
    iso_file = "local:iso/ubuntu-22.04.3-live-server-amd64.iso"
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = "64G"
        format = "raw"
        storage_pool = "<REDACTED>"
        type = "virtio"
    }

    efi_config {
      efi_storage_pool = "<REDACTED>"
      pre_enrolled_keys = true
      efi_type = "4m"
    }



    # VM CPU Settings
    cores = "4"
    cpu_type = "x86-64-v2-AES"

    # VM OS Settings
    os = "l26"
    
    # VM Memory Settings
    memory = "4096" 

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr1"
        firewall = "false"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "<REDACTED>"

    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    # Disabled due to incompatibility with Proxmox > 6.2
    #boot = "c"
    boot = "order=virtio0;ide2"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "http" 

    ssh_username = "ansible"

    ssh_private_key_file = "<REDACTED>"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

    name = "kiratech-mngr-template"
    sources = ["source.proxmox-iso.kiratech-mngr-template"]

    # REQUIRED FOR CLOUD-INIT
    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt-get -y autoremove --purge",
            "sudo apt-get -y clean",
            "sudo apt-get -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    # REQUIRED FOR CLOUD-INIT
    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # REQUIRED FOR CLOUD-INIT
    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ 
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"
        ]
    }

    # Add additional provisioning scripts here

    # Install commonly needed packages
    provisioner "shell" {
        inline = [
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo apt-get update",
            "DEBIAN_FRONTEND=noninteractive sudo apt-get install -y wget curl glances ncdu vim htop btop ca-certificates gnupg lsb-release net-tools apt-utils neofetch update-motd tmux qemu-guest-agent mc pipx"
        ]
    }

    # Harden sshd configuration
    
    provisioner "file" {
        source = "files/sshd_config_template"
        destination = "/tmp/sshd_config"
    }

    provisioner "shell" {
        inline = [
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo cp /tmp/sshd_config /etc/ssh/sshd_config",
            "sudo chown root:root /etc/ssh/sshd_config",
            "sudo chmod 0644 /etc/ssh/sshd_config"
        ]
    }
    
    # Configure unattended-upgrades
    provisioner "file" {
        source = "files/20auto-upgrades_template"
        destination = "/tmp/20auto-upgrades"
    }

    provisioner "file" {
        source = "files/50unattended-upgrades_template"
        destination = "/tmp/50unattended-upgrades"
    }   

    provisioner "shell" {
        inline = [
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "DEBIAN_FRONTEND=noninteractive sudo apt-get install -y unattended-upgrades",
            "sudo cp /tmp/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades",
            "sudo chown root:root /etc/apt/apt.conf.d/20auto-upgrades",
            "sudo chmod 0644 /etc/apt/apt.conf.d/20auto-upgrades",
            "sudo cp /tmp/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades",
            "sudo chown root:root /etc/apt/apt.conf.d/50unattended-upgrades",
            "sudo chmod 0644 /etc/apt/apt.conf.d/50unattended-upgrades"
        ]
    }

    # Set locale as it-IT and system language as en-US

    provisioner "shell" {
        inline = [
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo locale-gen en_US.UTF-8",
            "sudo update-locale LANG=en_US.UTF-8 LC_NUMERIC=it_IT.UTF-8 LC_TIME=it_IT.UTF-8 LC_MONETARY=it_IT.UTF-8 LC_PAPER=it_IT.UTF-8 LC_NAME=it_IT.UTF-8 LC_ADDRESS=it_IT.UTF-8 LC_TELEPHONE=it_IT.UTF-8 LC_MEASUREMENT=it_IT.UTF-8 LC_IDENTIFICATION=it_IT.UTF-8"
        ]
    }

    # Install docker

    provisioner "shell" {
        inline = [
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo install -m 0755 -d /etc/apt/keyrings",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
            "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
            "echo \"deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \"$(. /etc/os-release && echo \"$UBUNTU_CODENAME\")\" stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
            "sudo apt-get update",
            "DEBIAN_FRONTEND=noninteractive sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin python3-docker containerd.io python3-dockerpty python3-docopt python3-dotenv python3-texttable"
        ]
    }

    # Configure neofetch

    provisioner "file" {
        source = "files/02-neofetch"
        destination = "/tmp/02-neofetch"
    }

    provisioner "shell" {
        inline = [
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo mv /tmp/02-neofetch /etc/update-motd.d/02-neofetch",
            "sudo chmod +x /etc/update-motd.d/02-neofetch"
        ]
    }

    # Disable swap for Kubernetes

    provisioner "shell" {
        inline = [
            "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
            "sudo sed -i '/ swap / s/^/#/' /etc/fstab",
            "sudo swapoff -a"
        ]
    }

    # Reconfigure TZDATA
    provisioner "file" {
        source = "files/tmp_tzdata"
        destination = "/tmp/tmp_tzdata"
    }

    provisioner "shell" {
    inline = [
        "echo \"${var.ansible_user_password}\" | sudo -S echo 'inserted sudo password in memory'",
        "sudo chmod 0644 /tmp/tmp_tzdata",
        "sudo chown root:root /tmp/tmp_tzdata",
        "export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true",
        "sudo debconf-set-selections /tmp/tmp_tzdata",
        "sudo rm /etc/localtime /etc/timezone",
        "sudo dpkg-reconfigure -f noninteractive tzdata"
        ]
    }
       
}
