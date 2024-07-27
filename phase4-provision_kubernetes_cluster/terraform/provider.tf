terraform {
  required_providers {
    rke = {
      source  = "rancher/rke"
      version = "1.5.0" # Tried deployment with latest version due to version constraints not being specified in the challenge
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "4.2.0" # Tried deployment with latest version due to version constraints not being specified in the challenge
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31.0" # Tried deployment with latest version due to version constraints not being specified in the challenge
    }
  }
}

provider "rke" {
  debug = true # DISABLE IN PROD
  log_file = "./logs/rke_logs.log"
}

provider "kubernetes" {
  config_path = "${path.module}/kube_config.yaml"
}