
variable "k8s_version" {
  type = string
}

variable "master_ip" {
  type = string
}

variable "worker1_ip" {
  type = string
}

variable "worker2_ip" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "ssh_user_sudo_password" { # MUST BE REMOVED FROM FINAL FILE IF NOT USED
  type = string
  sensitive = true
}

variable "ssh_key_path" {
  type = string
}

variable "rancher_hostname" {
  type = string
}

variable "cluster_namespace" {
  type = string  
}