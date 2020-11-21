# Kube Cluster

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = var.cluster_name
  region  = "nyc1"
  version = "1.19.3-do.2"

  node_pool {
    name       = var.cluster_nodes_name
    size       = "s-2vcpu-2gb"
    node_count = 2
    tags       = [var.cluster_nodes_name]
  }
}


resource "kubernetes_namespace" "vote_namespace" {
  metadata {
    name = "vote"
  }
}

resource "local_file" "kubernetes_config" {
  content  = digitalocean_kubernetes_cluster.cluster.kube_config.0.raw_config
  filename = "${var.kubeconfig_name}.yml"
}

# Container Registry

resource "digitalocean_container_registry" "registry" {
  name                   = "voting-app-example"
  subscription_tier_slug = "basic"
}

resource "digitalocean_container_registry_docker_credentials" "registry_credentials" {
  registry_name = "voting-app-example"

  depends_on = [digitalocean_container_registry.registry]
}

resource "kubernetes_secret" "registry_credentials_secret" {
  metadata {
    name = "voting-app-example-do-registry"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.registry_credentials.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [digitalocean_container_registry_docker_credentials.registry_credentials]
}

# Load Balancer

resource "digitalocean_loadbalancer" "loadbalancer" {
  name   = var.loadbalancer_name
  region = "nyc1"

  forwarding_rule {
    entry_port     = 5000
    entry_protocol = "http"

    target_port     = 5000
    target_protocol = "http"
  }

  healthcheck {
    port     = 5000
    protocol = "tcp"
  }

  forwarding_rule {
    entry_port     = 5001
    entry_protocol = "http"

    target_port     = 5001
    target_protocol = "http"
  }

  healthcheck {
    port     = 5001
    protocol = "tcp"
  }

  droplet_tag = var.cluster_nodes_name
}
