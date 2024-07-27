
# Create Cluster

resource "rke_cluster" "kiratech_rancher_cluster" {

  cluster_name = "kiratech-k8s-rancher-cluster"
  kubernetes_version = var.k8s_version
  enable_cri_dockerd = true

  nodes {
    address = var.master_ip
    user    = var.ssh_user
    role    = ["controlplane", "etcd", "worker"]
    ssh_key = file(var.ssh_key_path)
  }

  nodes {
    address = var.worker1_ip
    user    = var.ssh_user
    role    = ["worker"]
    ssh_key = file(var.ssh_key_path)
  }

  nodes {
    address = var.worker2_ip
    user    = var.ssh_user
    role    = ["worker"]
    ssh_key = file(var.ssh_key_path)
  }

}

# Create Namespace

resource "local_file" "kube_config_yaml" {
  content = "${rke_cluster.kiratech_rancher_cluster.kube_config_yaml}"
  filename = "${path.root}/kube_config.yaml"
}

resource "kubernetes_namespace" "kiratech-test" {
  metadata {
    name = var.cluster_namespace
  }
}

# Configure Kube-bench

resource "kubernetes_config_map" "kube_bench_config" {
  metadata {
    name      = "kube-bench-config"
    namespace = kubernetes_namespace.kiratech-test.metadata[0].name
  }

  data = {
    "kube-bench-config.yaml" = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-bench-config
  namespace: kiratech-test
data:
  kube-bench-config.yaml: |
    # Add any specific kube-bench configuration here
EOF
  }
}

# Create job for running Kube-bench

#resource "kubernetes_job" "kube_bench_job" {
  #metadata {
    #name      = "kube-bench"
    #namespace = kubernetes_namespace.kiratech-test.metadata[0].name
  #}

  #spec {
    #template {
      #metadata {
        #labels = {
          #app = "kube-bench"
        #}
      #}

      #spec {
        #container {
          #name  = "kube-bench"
          #image = "aquasec/kube-bench:latest"

          #command = [
            #"/kube-bench",
            #"--version",
            #var.k8s_version
          #]

          #volume_mount {
            #name      = "kube-bench-config-volume"
            #mount_path = "/etc/kube-bench"
          #}
        #}

        #restart_policy = "Never"

        #volume {
          #name = "kube-bench-config-volume"

          #config_map {
            #name = kubernetes_config_map.kube_bench_config.metadata[0].name
          #}
        #}
      #}
    #}

    #backoff_limit = 4
  #}
#}