locals {
  name = var.override_name == null ? "${lower(var.system_short_name)}-${lower(var.app_name)}-${lower(var.environment)}-ag" : var.override_name
}

resource "azurerm_monitor_action_group" "monitor_action_group" {
  name                = var.name
  resource_group_name = var.azurerm_resource_group.name
  short_name          = var.short_name

  dynamic "arm_role_receiver" {
    for_each = (var.configuration.arm_role_receiver == null) ? {} : var.configuration.arm_role_receiver

    content {
      name                    = arm_role_receiver.value.name
      role_id                 = split("/", arm_role_receiver.value.id)[4] # https://github.com/hashicorp/terraform-provider-azurerm/issues/8553
      use_common_alert_schema = true
    }
  }

  dynamic "email_receiver" {
    for_each = (var.configuration.email_receiver == null) ? [] : toset(var.configuration.email_receiver)

    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = email_receiver.value.use_common_alert_schema
    }
  }

  tags = var.tags
}
