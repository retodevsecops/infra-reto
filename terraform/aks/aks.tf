
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
    storage_account_name = "sa_reto_devsecops"
    container_name       = "sc_reto_devsecops_aks"
    key                  = "reto.terraform.tfstate"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "node_reto"
    node_count = var.agent_count
    vm_size    = "Standard_D4ds_v5"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
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