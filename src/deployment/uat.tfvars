# Cloud Engineering Framework
client_environment          = "uat"
client_project_dependencies = []

cloud_account_id   = "39bf8bc4-faf3-42f1-a711-1e975d794c60" // moula.uat
cloud_multi_region = true
custom_tags        = {}

# App Service
as_application_1 = {
  name = "facilityquery",
  type = "as",
  primary = {
    ai_config = {
      required                     = true,
      existing_id                  = null,
      existing_instrumentation_key = null
      type                         = "web"
    },
    asp_config = {
      required    = true,
      existing_id = null,
      sku_tier    = "Premium",
      sku_size    = "P1v2",
      kind        = "Windows"
    },
    as_config = {
      slots_required = true,
      stack          = "DOTNETCORE|3.1",
      always_on      = true,
      ip_allow_list = [
        {
          ip_address = "110.120.130.140/32",
          name       = "AllowOfficeIP",
          priority   = 100,
          action     = "Allow"
        },
        {
          service_tag = "AzureFrontDoor.Backend",
          name        = "AllowAzureFrontDoor",
          priority    = 200,
          action      = "Allow"
        },
      ]
    }
  },
  secondary = null
  # If multi-region is not required, use `secondary = null` instead
}
