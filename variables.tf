variable "resource_group_name" {
  default = "IAAC-AZURE-OPDO"
}

variable "resource_group_location" {
  default = "Switzerland North"
}

variable "azurerm_log_analytics_workspace" {
  default = "OPDO-LOGS"
}

variable "prefix" {
  default = "opdo"
}

variable "azurerm_subnet_name" {
  default = "opdo-int-subnet"
}

variable "ip_configuration" {
    default = "opdo-ip"
}