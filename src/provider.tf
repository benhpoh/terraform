provider "azurerm" {
  features {}
  skip_provider_registration = true
  disable_terraform_partner_id = true
  partner_id = var.cloud_partner_id
}