#Common
variable "resource_group_name" {
  description = "Hosting resource group name"
}

variable "location" {
  description = "Azure Location"
}

variable "tags" {
  type        = map(string)
  description = "tags"

  validation {
    condition     = length(var.tags) > 0
    error_message = "Tags must contain more than 1 value."
  }
}

# NAMESPACE
variable "namespace_name" {
  description = "Notification Hub Namespace name"
}

variable "namespace_type" {
  type        = string
  description = "The Type of Namespace - possible values are Messaging or NotificationHub."

  validation {
    condition     = contains(["Messaging", "NotificationHub"], var.namespace_type)
    error_message = "Possible values are Messaging or NotificationHub."
  }
}

variable "sku_name" {
  type        = string
  description = "The name of the SKU to use for this Notification Hub Namespace. Possible values are Free, Basic or Standard."

  validation {
    condition     = contains(["Free", "Basic", "Standard"], var.sku_name)
    error_message = "Possible values are Free, Basic or Standard."
  }
}


# NOTIFICATION HUB
variable "notification_hub_names" {
  type        = list(string)
  description = "A list of Notification Hub names to create."

  validation {
    condition     = length(var.notification_hub_names) > 0
    error_message = "Must provide at least one notification hub name."
  }
}
