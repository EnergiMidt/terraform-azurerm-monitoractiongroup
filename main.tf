locals {
  name = var.override_name == null ? "${lower(var.system_short_name)}-${lower(var.app_name)}-${lower(var.environment)}-ag" : var.override_name
}

resource "azurerm_monitor_action_group" "monitor_action_group" {
  name                = local.name
  resource_group_name = var.azurerm_resource_group.name
  short_name          = "${title(substr(var.system_short_name, 0, 2))}${title(substr(var.app_name, 0, 6))}${title(substr(var.environment, 0, 4))}"

  dynamic "arm_role_receiver" {
    for_each = (var.configuration.arm_role_receiver == null) ? {} : var.configuration.arm_role_receiver

    content {
      name                    = arm_role_receiver.value.name
      role_id                 = split("/", arm_role_receiver.value.id)[4] # https://github.com/hashicorp/terraform-provider-azurerm/issues/8553
      use_common_alert_schema = try(arm_role_receiver.value.use_common_alert_schema, true)
    }
  }

  dynamic "azure_function_receiver" {
    for_each = (var.configuration.azure_function_receiver == null) ? {} : var.configuration.azure_function_receiver
    content {
      name                     = lookup(azure_function_receiver.value, "name", null)
      function_app_resource_id = lookup(azure_function_receiver.value, "function_app_resource_id", null)
      function_name            = lookup(azure_function_receiver.value, "function_name", null)
      http_trigger_url         = lookup(azure_function_receiver.value, "http_trigger_url", null)
      use_common_alert_schema  = try(azure_function_receiver.value.use_common_alert_schema, true)
    }
  }

  dynamic "email_receiver" {
    for_each = (var.configuration.email_receiver == null) ? [] : toset(var.configuration.email_receiver)

    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = try(email_receiver.value.use_common_alert_schema, true)
    }
  }

  tags = var.tags
}
