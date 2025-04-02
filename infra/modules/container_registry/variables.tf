variable "name" {
  type        = string
  description = "ACR Name"
}

variable "resource_group_name" {
  type        = string
  description = "RSG Name"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "sku" {
  type        = string
  description = "ACR SKU"
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard or Premium"
  }
}

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "ACR Admin Enabled"
}

variable "tags" {
  type        = map(string)
  description = "ACR Tags"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "ACR public network access"
}

variable "default_action" {
  type    = string
  default = "Deny"
  validation {
    condition     = contains(["Allow", "Deny"], var.default_action)
    error_message = "Default Action must be Allow or Deny"
  }
}

variable "ip_rules" {
  type = list(object({
    ip_range = list(string)
    action   = string
  }))

  default = [{
    "ip_range" = ["10.0.0.1/16"],
    "action"   = "Allow"
  }]

  description = "IP Rules"
}