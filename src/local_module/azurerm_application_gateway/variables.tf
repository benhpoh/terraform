variable "name" {
  description = "Application Gateway name"
}
variable "resource_group_name" {
}
variable "location" {
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."

  validation {
    condition     = contains(["Standard_Small", "Standard_Medium", "Standard_Large", "Standard_v2", "WAF_Medium", "WAF_Large", "WAF_v2"], var.sku_name)
    error_message = "Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."
  }
}

variable "sku_tier" {
  type        = string
  description = "The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2."

  validation {
    condition     = contains(["Standard", "Standard_v2", "WAF", "WAF_v2"], var.sku_tier)
    error_message = "Possible values are Standard, Standard_v2, WAF and WAF_v2."
  }
}

variable "sku_capacity" {
  type        = number
  description = "When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU."
}

variable "gateway_ip_configurations" {
  type        = list(object({ name : string, subnet_id : string }))
  description = "A list of objects containing 2 keys: name (Name of this Gateway IP Configuration) & subnet_id (ID of the Subnet which the Application Gateway should be connected to)."
}

variable "frontend_ip_configurations" {
  type        = list(any)
  description = "A list of objects containing the following keys: name, subnet_id, private_ip_address, public_ip_address_id, private_ip_address_allocation"
}

variable "backend_address_pools" {
  type        = list(any)
  description = "A list of objects containing the following keys: name (string), fqdns (list of strings), ip_addresses (list of strings)"
}

variable "backend_http_settings" {
  type        = list(any)
  description = "A list of objects containing the following keys: cookie_based_affinity ('Enabled' / 'Disabled'), name (string), port (number), path (string)"
}

variable "http_listeners" {
  type        = list(any)
  description = "A list of objects containing the following keys: name (string), frontend_ip_configuration_name (string), frontend_port_name (string), path (string)"
}

variable "request_routing_rules" {
  type        = list(any)
  description = "A list of objects containing the following keys: name (string), http_listener_name (string)"
}
