variable "client_id" {
  description = "Client ID (team)"
}

variable "client_project_id" {
  description = "Project ID"
  validation {
    condition     = length(var.client_project_id) > 3 && length(var.client_project_id) < 12
    error_message = "Client_project_id must be > 3 && < 12 characters."
  }
}

variable "client_project_repo" {
  description = "Project source control repository"
  validation {
    condition     = length(var.client_project_repo) > 10
    error_message = "Client_project_repo must be > 10 characters."
  }
}

variable "client_environment" {
  description = "Environment eg dev"

  validation {
    condition     = contains(["dev", "test", "uat", "sandbox", "demo", "prod"], var.client_environment)
    error_message = "Client_environment must be one of the following 'dev, test, uat, sandbox, demo, prod'."
  }
}

variable "cloud_tenant_id" {
  description = "Tenant ID"
  type        = string

  validation {
    condition     = length(split("-", var.cloud_tenant_id)[0]) == 8 && length(split("-", var.cloud_tenant_id)[1]) == 4 && length(split("-", var.cloud_tenant_id)[2]) == 4 && length(split("-", var.cloud_tenant_id)[3]) == 4 && length(split("-", var.cloud_tenant_id)[4]) == 12
    error_message = "Cloud_tenant_id must be in this format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX (8-4-4-4-12)."
  }
}

variable "cloud_account_id" {
  description = "Subscription ID"
  type        = string

  validation {
    condition     = length(split("-", var.cloud_account_id)[0]) == 8 && length(split("-", var.cloud_account_id)[1]) == 4 && length(split("-", var.cloud_account_id)[2]) == 4 && length(split("-", var.cloud_account_id)[3]) == 4 && length(split("-", var.cloud_account_id)[4]) == 12
    error_message = "Cloud_account_id must be in this format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX (8-4-4-4-12)."
  }
}

variable "cloud_location_1" {
  description = "Cloud Location (region)"
  type        = object({ name : string, alias : string })

  validation {
    condition     = contains(["Australia Southeast", "Australia East"], var.cloud_location_1.name) && contains(["ause", "auea"], var.cloud_location_1.alias)
    error_message = "Cloud_location_1.name must be either 'Australia Southeast' / 'Australia East', & Cloud_location_1.alias either 'ause' / 'auea'."
  }
}

variable "cloud_location_2" {
  description = "Cloud Location (region)"
  type        = object({ name : string, alias : string })

  validation {
    condition     = contains(["Australia Southeast", "Australia East"], var.cloud_location_2.name) && contains(["ause", "auea"], var.cloud_location_2.alias)
    error_message = "Cloud_location_2.name must be either 'Australia Southeast' / 'Australia East', & Cloud_location_2.alias either 'ause' / 'auea'."
  }
}

variable "cloud_multi_region" {
  description = "Cloud Multi Region Region Required"
  type        = bool
}

variable "cloud_partner_id" {
  description = "Cloud partner id"
  type        = string

  validation {
    condition     = length(split("-", var.cloud_partner_id)[0]) == 8 && length(split("-", var.cloud_partner_id)[1]) == 4 && length(split("-", var.cloud_partner_id)[2]) == 4 && length(split("-", var.cloud_partner_id)[3]) == 4 && length(split("-", var.cloud_partner_id)[4]) == 12
    error_message = "Cloud_partner_id must be in this format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX (8-4-4-4-12)."
  }
}

variable "custom_tags" {
  type = map(string)
}
