resource "azurerm_application_gateway" "network" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  enable_http2        = true

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = 2
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configuration
    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }

  frontend_port {
    name = "HTTP"
    port = 80
  }

  frontend_port {
    name = "HTTPS"
    port = 443
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configurations
    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                         = frontend_ip_configuration.value.name
      subnet_id                    = try(frontend_ip_configuration.value.subnet_id, null)
      private_ip_address           = try(frontend_ip_configuration.value.private_ip_address, null)
      public_ip_address_id         = try(frontend_ip_configuration.value.public_ip_address_id, null)
      public_ip_address_allocation = try(frontend_ip_configuration.value.public_ip_address_allocation, null)
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      fqdns        = try(backend_address_pool.value.fqdns, null)
      ip_addresses = try(backend_address_pool.value.ip_addresses, null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      name                  = backend_http_settings.value.name
      port                  = backend_http_settings.value.port
      path                  = try(backend_http_settings.value.path, null)
      protocol              = "Https"
      request_timeout       = 60
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = "Https"
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = "Basic"
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = "${var.name}-beap"
      backend_http_settings_name = "${var.name}-httpsettings"
    }
  }
}
