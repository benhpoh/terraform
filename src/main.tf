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

module "azurerm_notification_hub" {
  source = "./local_module/azurerm_notification_hub"

  namespace_name      = local.shared_primary_name
  resource_group_name = module.azurerm_resource_group_primary.name
  location            = module.azurerm_resource_group_primary.location

  namespace_type = "NotificationHub"
  sku_name       = "Free"

  notification_hub_names = ["notification-hub-name"]

  tags = merge(local.tags, var.custom_tags)
}

output "notification_hub_id" {
  value = module.azurerm_notification_hub.notification_hub_ids
}

output "notification_hub_connstrings" {
  value = module.azurerm_notification_hub.notification_hub_auth_rule_connstrings
}
