variable "name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Resource Group Location"
}

variable "tags" {
  type        = map(string)
  description = "Resource Group Tags"
}