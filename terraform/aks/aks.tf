
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.CLUSTER_NAME
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  dns_prefix          = var.DNS_PREFIX

  default_node_pool {
    name       = "nodereto"
    node_count = 1
    vm_size    = "Standard_D4ds_v5"
  }

  # service_principal {
  #   client_id     = var.CLIENT_ID
  #   client_secret = var.CLIENT_SECRET
  # }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "basic"
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
    name = "qa-reto"
  }
}

resource "kubernetes_namespace" "pdn-reto" {
  depends_on = [azurerm_kubernetes_cluster.k8s]
  metadata {
    name = "pdn-reto"
  }
}