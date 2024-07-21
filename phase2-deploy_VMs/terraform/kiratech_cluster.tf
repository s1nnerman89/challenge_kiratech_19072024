# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "kiratech-mngr-01" {
    
    # VM General Settings
    target_node = "<REDACTED>"
    name = "kiratech-mngr-01"
    desc = "### Ubuntu Server 22.04 VM - 'kiratech-mngr-01'\nKubernetes Manager\n_Deployed with HCP Terraform_\nStatic ip configured in router as 192.168.0.103"
    tags = "ubuntu-server;kubernetes-mngr"

    # VM Advanced General Settings
    onboot = false
    oncreate = true
    tablet = true
    machine = "q35"

    # VM Bios Settings
    bios = "ovmf"

    # VM OS Settings
    clone = "kiratech-mngr-template"
    full_clone = true
    qemu_os = "l26"

    # VM System Settings
    agent = 1
    scsihw = "virtio-scsi-pci"
    
    # VM CPU Settings
    cores = 4
    sockets = 1
    cpu = "x86-64-v2-AES"    
    
    # VM Memory Settings
    memory = 4096

    # VM Network Settings
    network {
        bridge = "vmbr1"
        model  = "virtio"
        macaddr = "36:c1:7b:9e:c5:8a"
        firewall = false
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    ipconfig0 = "ip=dhcp"
    
    ssh_user = "ansible"
    ssh_private_key = file("<REDACTED>")

    cicustom = "user=local:snippets/kiratech-mngr-01_initial_customization.yaml"
      
}

resource "proxmox_vm_qemu" "kiratech-wrkr-01" {
    
    # VM General Settings
    target_node = "<REDACTED>"
    name = "kiratech-wrkr-01"
    desc = "### Ubuntu Server 22.04 VM - 'kiratech-wrkr-01'\nKubernetes Worker\n_Deployed with HCP Terraform_\nStatic ip configured as 192.168.0.101"
    tags = "ubuntu-server;kubernetes-wrkr"

    # VM Advanced General Settings
    onboot = false
    oncreate = true
    tablet = true
    machine = "q35"

    # VM Bios Settings
    bios = "ovmf"

    # VM OS Settings
    clone = "kiratech-wrkr-template"
    full_clone = true
    qemu_os = "l26"

    # VM System Settings
    agent = 1
    scsihw = "virtio-scsi-pci"
    
    # VM CPU Settings
    cores = 2
    sockets = 1
    cpu = "x86-64-v2-AES"    
    
    # VM Memory Settings
    memory = 2048

    # VM Network Settings
    network {
        bridge = "vmbr1"
        model  = "virtio"
        macaddr = "ba:78:34:4a:bf:d9"
        firewall = false
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=dhcp"

    ssh_user = "ansible"
    ssh_private_key = file("<REDACTED>")

    cicustom = "user=local:snippets/kiratech-wrkr-01_initial_customization.yaml"

}

resource "proxmox_vm_qemu" "kiratech-wrkr-02" {
    
    # VM General Settings
    target_node = "<REDACTED>"
    name = "kiratech-wrkr-02"
    desc = "### Ubuntu Server 22.04 VM - 'kiratech-wrkr-02'\nKubernetes Worker\n_Deployed with HCP Terraform_\nStatic ip configured as 192.168.0.102"
    tags = "ubuntu-server;kubernetes-wrkr"

    # VM Advanced General Settings
    onboot = false
    oncreate = true
    tablet = true
    machine = "q35"

    # VM Bios Settings
    bios = "ovmf"

    # VM OS Settings
    clone = "kiratech-wrkr-template"
    full_clone = true
    qemu_os = "l26"

    # VM System Settings
    agent = 1
    scsihw = "virtio-scsi-pci"
    
    # VM CPU Settings
    cores = 2
    sockets = 1
    cpu = "x86-64-v2-AES"    
    
    # VM Memory Settings
    memory = 2048

    # VM Network Settings
    network {
        bridge = "vmbr1"
        model  = "virtio"
        macaddr = "72:98:22:c4:7f:a0"
        firewall = false
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=dhcp"
    
    ssh_user = "ansible"
    ssh_private_key = file("<REDACTED>")

    cicustom = "user=local:snippets/kiratech-wrkr-02_initial_customization.yaml"

}

resource "null_resource" "cloud-init_snippets" {
  connection {
    type = "ssh"
    user = "${var.pve_user}"
    host = "${var.pve_host}"
    private_key = "${file("<REDACTED>")}"
  }

  provisioner "file" {
    source = "files/kiratech-mngr-01_initial_customization.yaml"
    destination = "/var/lib/vz/snippets/kiratech-mngr-01_initial_customization.yaml"
  }

  provisioner "file" {
    source = "files/kiratech-wrkr-01_initial_customization.yaml"
    destination = "/var/lib/vz/snippets/kiratech-wrkr-01_initial_customization.yaml"
  }

  provisioner "file" {
    source = "files/kiratech-wrkr-02_initial_customization.yaml"
    destination = "/var/lib/vz/snippets/kiratech-wrkr-02_initial_customization.yaml"
  }
}