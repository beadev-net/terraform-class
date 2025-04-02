variable "name" {
  type        = string
  description = "UAI Name"
}

variable "location" {
  type        = string
  description = "UAI Location"
}

variable "resource_group_name" {
  type        = string
  description = "UAI resource_group_name"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}

variable "role_assignments" {
  type = map(object({
    scope                = string
    role_definition_name = string
  }))

  default = {
    acr = {
      scope                = "Principal ID"
      role_definition_name = "Reader"
    }
  }

  description = "UAI Role Assignments"
}