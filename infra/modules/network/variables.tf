variable "name" {
  type        = string
  description = "The name of the virtual network."
}

variable "location" {
  type        = string
  description = "The location where the virtual network will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the virtual network will be created."
}

variable "address_space" {
  type        = list(string)
  description = "The address space for the virtual network."
}

variable "dns_servers" {
  type        = list(string)
  description = "The DNS servers for the virtual network."
  default     = []
}

variable "subnets" {
  type = list(object({
    name             = string
    address_prefixes = list(string)
    security_group   = optional(string)
    delegation = optional(object({
      name = string
      service_delegation = optional(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  description = "A list of subnets to be created within the virtual network."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the virtual network."
}