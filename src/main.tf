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

module "azurerm_resource_group_secondary" {
  source = "git::ssh://git@bitbucket.org/moula/infrastructure-as-code.git//azurerm/azurerm_resource_group"
  count  = var.cloud_multi_region ? 1 : 0

  name     = local.shared_primary_name
  location = var.cloud_location_1.name

  tags = merge(local.tags, var.custom_tags)
}

# module "azurerm_app_service_primary" {
#   source = "git::ssh://git@bitbucket.org/moula/infrastructure-as-code.git//azurerm/azurerm_app_service"

#   name                = "${var.client_project_id}-${var.cloud_location_1.alias}-${var.client_environment}"
#   resource_group_name = module.azurerm_resource_group_primary.name
#   location            = module.azurerm_resource_group_primary.location

#   ai_config  = var.as_application_1.primary.ai_config
#   asp_config = var.as_application_1.primary.asp_config
#   as_config  = var.as_application_1.primary.as_config
#   as_app_settings = {
#     "ASPNETCORE_ENVIRONMENT"   = var.client_environment
#   }
#   as_connection_strings = [
#     {
#       "name" : "xDbConnection",
#       "value" : "@Microsoft.KeyVault(VaultName=x-kv;SecretName=x-dbconnection)",
#       "type" : "SQLServer"
#     },
#   ] // leave as [] if no connection strings required.

#   tags = merge(local.tags, var.custom_tags)
# }
