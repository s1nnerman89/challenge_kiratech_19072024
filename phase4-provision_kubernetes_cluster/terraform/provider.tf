terraform {
  required_providers {
    rke = {
      source  = "rancher/rke"
      version = "1.5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31.0"
    }
  }
}

provider "rke" {
  debug = false # DISABLE IN PROD
  log_file = "./logs/rke_logs.log"
}

provider "kubernetes" {
  config_path = local_file.kube_config_yaml.filename
}