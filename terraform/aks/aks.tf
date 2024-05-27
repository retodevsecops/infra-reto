
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg_reto_devsecops"
    storage_account_name = "saretodevsecops"
    container_name       = "scretodevsecopsaks"
    key                  = "reto.terraform.tfstate"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.CLUSTER_NAME
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  dns_prefix          = var.DNS_PREFIX

  default_node_pool {
    name       = "node_reto"
    node_count = 1
    vm_size    = "Standard_D4ds_v5"
  }

  service_principal {
    client_id     = var.ARM_CLIENT_ID
    client_secret = var.ARM_CLIENT_SECRET
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }

  tags = {
    Environment = "Production"
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "qa-reto" {
  depends_on = [azurerm_kubernetes_cluster.k8s]
  metadata {
    name = "qa-#{namespace}#"
  }
}

resource "kubernetes_namespace" "pdn-reto" {
  depends_on = [azurerm_kubernetes_cluster.k8s]
  metadata {
    name = "pdn-#{namespace}#"
  }
}