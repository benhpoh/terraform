resource "azurerm_notification_hub_namespace" "default" {
  name                = "${var.namespace_name}-ns"
  resource_group_name = var.resource_group_name
  location            = var.location

  namespace_type = var.namespace_type
  sku_name       = var.sku_name

  tags = var.tags
}

resource "azurerm_notification_hub" "default" {
  for_each = toset(var.notification_hub_names)

  name                = each.value
  namespace_name      = azurerm_notification_hub_namespace.default.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_notification_hub_authorization_rule" "send" {
  for_each = azurerm_notification_hub.default

  name                  = "${each.value.name}-send"
  notification_hub_name = each.value.name
  namespace_name        = azurerm_notification_hub_namespace.default.name
  resource_group_name   = var.resource_group_name
  manage                = false
  send                  = true
  listen                = false
}

resource "azurerm_notification_hub_authorization_rule" "listen" {
  for_each = azurerm_notification_hub.default

  name                  = "${each.value.name}-listen"
  notification_hub_name = each.value.name
  namespace_name        = azurerm_notification_hub_namespace.default.name
  resource_group_name   = var.resource_group_name
  manage                = false
  send                  = false
  listen                = true
}

resource "azurerm_notification_hub_authorization_rule" "sendlisten" {
  for_each = azurerm_notification_hub.default

  name                  = "${each.value.name}-sendlisten"
  notification_hub_name = each.value.name
  namespace_name        = azurerm_notification_hub_namespace.default.name
  resource_group_name   = var.resource_group_name
  manage                = false
  send                  = true
  listen                = true
}
