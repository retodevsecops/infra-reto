
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_container_registry" "acr" {
  name                = var.ACR_NAME
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  sku                 = "Basic"
  admin_enabled       = true

  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [
  #     azurerm_user_assigned_identity.acr.id
  #   ]
  # }
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

resource "azurerm_role_assignment" "example" {
  principal_id                     = "4879f413-eafa-4997-880d-c484eefb705b"
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
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