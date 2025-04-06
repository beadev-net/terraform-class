variable "env_name" {
  type        = string
  description = "Container App Environment Name"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "resource_group_name" {
  type        = string
  description = "Container App Resource Group"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}

variable "containers" {
  type = map(object({
    name   = string
    image  = string
    cpu    = number
    memory = string
  }))

  description = "Container App"
}

variable "identity_ids" {
  type        = list(string)
  description = "List of Identity Resource ID"
}

variable "registry_server" {
  type        = string
  description = "Registry Server DNS *.acr.io"
}

variable "registry_identity_id" {
  type        = string
  description = "Managed Identity Resource ID"
}

variable "allow_insecure_connections" {
  type        = bool
  default     = true
  description = "Allow insecure connections"
}

variable "external_enabled" {
  type        = bool
  default     = true
  description = "Allow external connections"
}

variable "target_port" {
  type        = number
  default     = 80
  description = "Container Target Port"
}

variable "infra_subnet_id" {
  type        = string
  description = "Subnet ID for the Container App Environment"
}