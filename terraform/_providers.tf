provider "digitalocean" {
  token = var.digitalocean_token
}

provider "kubernetes" {
  config_path = local_file.kubernetes_config.filename
}