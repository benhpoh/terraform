locals {
  shared_primary_name   = "${var.client_project_id}-${var.cloud_location_1.alias}-${var.client_environment}"
  shared_secondary_name = "${var.client_project_id}-${var.cloud_location_2.alias}-${var.client_environment}"
  tags = {
    environment = var.client_environment
    provisioner = "terraform"
    owner       = var.client_id
    repo        = var.client_project_repo
  }
}

module "azurerm_resource_group_primary" {
  source = "git::ssh://git@bitbucket.org/moula/infrastructure-as-code.git//azurerm/azurerm_resource_group"

  name     = local.shared_primary_name
  location = var.cloud_location_1.name

  tags = merge(local.tags, var.custom_tags)
}

resource "azurerm_virtual_network" "example" {
  name                = "${local.shared_primary_name}-vnet"
  resource_group_name = module.azurerm_resource_group_primary.name
  location            = module.azurerm_resource_group_primary.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = module.azurerm_resource_group_primary.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = module.azurerm_resource_group_primary.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.254.2.0/24"]
}

resource "azurerm_public_ip" "default" {
  name                = "${local.shared_primary_name}-pip"
  resource_group_name = module.azurerm_resource_group_primary.name
  location            = module.azurerm_resource_group_primary.location
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = "No-Zone"
}

resource "azurerm_application_gateway" "network" {
  name                = "${local.shared_primary_name}-ag"
  resource_group_name = module.azurerm_resource_group_primary.name
  location            = module.azurerm_resource_group_primary.location
  enable_http2        = true

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  frontend_port {
    name = "HTTP"
    port = 80
  }

  frontend_port {
    name = "HTTPS"
    port = 443
  }

  gateway_ip_configuration {
    name      = "${local.shared_primary_name}-ag-gatewayconfig"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_ip_configuration {
    name                 = "${local.shared_primary_name}-ag-feip"
    public_ip_address_id = azurerm_public_ip.default.id
  }

  backend_address_pool {
    name = "${local.shared_primary_name}-ag-bep"
  }

  backend_http_settings {
    name                  = "${local.shared_primary_name}-ag-httpsettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "${local.shared_primary_name}-ag-listener"
    frontend_ip_configuration_name = "${local.shared_primary_name}-ag-feip"
    frontend_port_name             = "HTTP"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.shared_primary_name}-ag-routingrule"
    rule_type                  = "Basic"
    http_listener_name         = "${local.shared_primary_name}-ag-listener"
    backend_address_pool_name  = "${local.shared_primary_name}-ag-bep"
    backend_http_settings_name = "${local.shared_primary_name}-ag-httpsettings"
  }
}


# module "azurerm_application_gateway" {
#   source = "./local_module/azurerm_application_gateway"

#   name                = local.shared_primary_name
#   resource_group_name = module.azurerm_resource_group_primary.name
#   location            = module.azurerm_resource_group_primary.location

#   sku_name     = "Standard_v2"
#   sku_tier     = "Standard_v2"
#   sku_capacity = 2

#   gateway_ip_configurations = [{
#     name      = "${local.shared_primary_name}-ag-gatewayconfig"
#     subnet_id = azurerm_subnet.frontend.id
#   }]

#   frontend_ip_configurations = [{
#     name                 = "${local.shared_primary_name}-ag-feip"
#     public_ip_address_id = azurerm_public_ip.default.id
#   }]

#   backend_address_pools {
#     name = "${local.shared_primary_name}-ag-bep"
#   }

#   backend_http_settings {
#     name                  = "${local.shared_primary_name}-ag-httpsettings"
#     cookie_based_affinity = "Disabled"
#     path                  = "/"
#     port                  = 80
#   }

#   http_listeners = [{
#     name                           = "${local.shared_primary_name}-ag-listener"
#     frontend_ip_configuration_name = "${local.shared_primary_name}-ag-feip"
#     frontend_port_name             = "HTTP"
#   }]

#   request_routing_rules = [{
#     name               = "${local.shared_primary_name}-ag-routingrule"
#     http_listener_name = "${local.shared_primary_name}-ag-listener"
#   }]
# }
