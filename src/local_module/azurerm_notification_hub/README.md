# Terraform docs:

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/notification_hub

# Description
This creates a Notification Hub namespace, along with any Notification Hubs associated with it.

# Usage:
Insert the following code snippets within the specified parent files:

## /main.tf

```t
module "azurerm_notification_hub" {
  source = "git::ssh://git@bitbucket.org/moula/infrastructure-as-code.git//azurerm/azurerm_notification_hub"

  namespace_name      = local.shared_primary_name
  resource_group_name = module.azurerm_resource_group_primary.name
  location            = module.azurerm_resource_group_primary.location

  namespace_type = var.notification_hub_namespace_type
  sku_name       = var.notification_hub_namespace_sku

  notification_hub_names = var.notification_hubs

  tags = merge(local.tags, var.custom_tags)
}
```

## /variables.tf

```t
# NOTIFICATION HUB
variable "notification_hub_namespace_type" {
  type        = string
  description = "The Type of Namespace - possible values are Messaging or NotificationHub."

  validation {
    condition     = contains(["Messaging", "NotificationHub"], var.namespace_type)
    error_message = "Possible values are Messaging or NotificationHub."
  }
}

variable "notification_hub_namespace_sku" {
  type        = string
  description = "The name of the SKU to use for this Notification Hub Namespace. Possible values are Free, Basic or Standard."

  validation {
    condition     = contains(["Free", "Basic", "Standard"], var.sku_name)
    error_message = "Possible values are Free, Basic or Standard."
  }
}

variable "notification_hubs" {
  type        = list(string)
  description = "A list of Notification Hub names to create."

  validation {
    condition     = length(var.notification_hub_names) > 0
    error_message = "Must provide at least one notification hub name."
  }
}
```

## /deployment/$ENVIRONMENT.tfvars  (Example)

```t
notification_hub_namespace_type = "NotificationHub"
notification_hub_namespace_sku  = "Standard"
notification_hubs               = [
  "notification-hub-name",
]
```

# Outputs:

## notification_hub_namespace_id 

The Notification Hub Namespace Id

```
module.azurerm_notification_hub.notification_hub_namespace_id
```

## notification_hub_ids 

ID of individual notification hubs

```
module.azurerm_notification_hub.notification_hub_ids

# output
{
  "notification-hub-name1" = "/subscriptions/..../resourceGroups/..../providers/Microsoft.NotificationHubs/namespaces/..../notificationHubs/....",
  "notification-hub-name2" = "/subscriptions/..../resourceGroups/..../providers/Microsoft.NotificationHubs/namespaces/..../notificationHubs/....",
}
```

## notification_hub_auth_rule_connstrings 

Connection strings for notification hub auth rules

```
module.azurerm_notification_hub.notification_hub_auth_rule_connstrings

# output
{
  "notification-hub-name1" = {
    send       = "Endpoint=sb://****.servicebus.windows.net/;SharedAccessKeyName=****;SharedAccessKey=****",
    listen     = "Endpoint=sb://****.servicebus.windows.net/;SharedAccessKeyName=****;SharedAccessKey=****",
    sendlisten = "Endpoint=sb://****.servicebus.windows.net/;SharedAccessKeyName=****;SharedAccessKey=****",
  }
}
```