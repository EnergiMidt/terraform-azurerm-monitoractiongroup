variable "environment" {
  description = "(Required) The name of the environment."
  type        = string
  validation {
    condition = contains([
      "dev",
      "test",
      "prod",
    ], var.environment)
    error_message = "Possible values are dev, test, and prod."
  }
}

variable "configuration" {
  description = "(Required) The configuration for block type arguments."
  type        = any
}

variable "azurerm_resource_group" {
  description = "(Required) The Azure Resource Group resource."
}

variable "amount" {
  description = "(Required) The total amount of cost to track with the budget."
  type        = number
}

variable "time_grain" {
  description = <<EOT
(Optional) The time covered by a budget. Tracking of the amount will be reset based on the time grain.
Must be one of `BillingAnnual`, `BillingMonth`, `BillingQuarter`, `Annually`, `Monthly` and `Quarterly`.
Defaults to `Monthly`. Changing this forces a new resource to be created."
EOT
  type        = string
  default     = "Monthly"
}

variable "system_short_name" {
  description = <<EOT
(Required) Short abbreviation (to-three letters) of the system name that this resource belongs to (see naming convention guidelines).
Will be part of the final name of the deployed resource.
EOT
  type        = string
}

variable "app_name" {
  description = <<EOT
(Required) Name of this resource within the system it belongs to (see naming convention guidelines).
Will be part of the final name of the deployed resource.
EOT
  type        = string
}

variable "override_name" {
  description = "(Optional) Override the name of the resource. Under normal circumstances, it should not be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
