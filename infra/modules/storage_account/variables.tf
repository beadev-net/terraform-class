variable "name" {
  type        = string
  description = "Storage Account Name"
}

variable "resource_group_name" {
  type        = string
  description = "RSG Name"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Public access"
}

variable "queue_name" {
  type        = string
  description = "Queue Name"
}