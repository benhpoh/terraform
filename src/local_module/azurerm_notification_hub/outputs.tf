output "notification_hub_namespace_id" {
  description = "Notification Hub Namespace Id"
  value       = azurerm_notification_hub_namespace.default.id
}

output "notification_hub_ids" {
  description = "ID of individual notification hubs"
  value       = { for notification_hub in azurerm_notification_hub.default : notification_hub.name => notification_hub.id }
}

output "notification_hub_auth_rule_connstrings" {
  description = "Connection strings for notification hub auth rules"
  value = { for notification_hub in azurerm_notification_hub.default : notification_hub.name => {
    send : "Endpoint=sb://${azurerm_notification_hub_namespace.default.name}.servicebus.windows.net/;SharedAccessKeyName=${notification_hub.name}-listen;SharedAccessKey=${azurerm_notification_hub_authorization_rule.listen[notification_hub.name].primary_access_key}",
    listen : "Endpoint=sb://${azurerm_notification_hub_namespace.default.name}.servicebus.windows.net/;SharedAccessKeyName=${notification_hub.name}-listen;SharedAccessKey=${azurerm_notification_hub_authorization_rule.listen[notification_hub.name].primary_access_key}",
    sendlisten : "Endpoint=sb://${azurerm_notification_hub_namespace.default.name}.servicebus.windows.net/;SharedAccessKeyName=${notification_hub.name}-sendlisten;SharedAccessKey=${azurerm_notification_hub_authorization_rule.sendlisten[notification_hub.name].primary_access_key}",
  } }
}

