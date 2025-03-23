// Standard or calculated local values:
locals {
  common_tags = {
    managed_by : "terraform"
    environment : "dev"
  }

  # Creates a single list of tags, order is important as it allows var.tags to override a common tag
#   all_tags = merge(local.common_tags, var.tags)

  # Environment configuration:
  subscription_id = {
    dev : "b1939b25-807e-43a4-8f19-c1055b6d8fc4"
  }

  databricks_account_id = "cb9e3e61-c203-44c3-adad-a99d4d28696d"

#   name_suffix = "${var.service_name}-${var.environment}-${var.location}"

  # Long to shortcode mapping
  loc = {
    uksouth : "uks",
    centralindia: "in"
  }

  # Validations
  valid_environments = ["dev"]
  valid_env_string   = join(", ", [for env in local.valid_environments : format("%q", env)])

  valid_locations  = ["uksouth", "westeurope", "centralindia"]
  valid_loc_string = join(", ", [for loc in local.valid_locations : format("%q", loc)])
}
