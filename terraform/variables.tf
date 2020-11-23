variable "digitalocean_token" {}

variable "loadbalancer_name" {
  description = "Loadbalancer name"
  default     = "loadbalancer-1"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name"
  default     = "production"
  type        = string
}

variable "cluster_nodes_name" {
  description = "Node name"
  default     = "production-node"
  type        = string
}

variable "kubeconfig_name" {
  description = "kubeconfig file name"
  default     = "kubeconfig"
  type        = string
}

variable "registry_name" {
  description = "Registry name"
  default     = "production-registry"
  type        = string
}