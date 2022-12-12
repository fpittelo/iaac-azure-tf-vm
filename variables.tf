variable "rg_name" {
  default = "iaac_azure_opdo"
}

variable "rg_location" {
  default = "Switzerland North"
}

variable "log_analytics_wks" {
  default = "opdo-logs"
}

variable "prefix" {
  default = "opdo"
}

variable "opdo_virtual_net" {
  default = "opdo_virtual_net"
}

variable "opdo_subnet_int" {
  default = "opdo_subnet_int"
}

variable "opdo_subnet_pub" {
  default = "opdo_subnet_pub"
}

variable "opdo_vm01_ipcfg" {
    default = "opdo_vm01_ipcfg"
}

variable "opdo_vm01_nic" {
    default = "opdo_vm01_nic"
}

variable "opdo_vm01_intip" {
  default = "opdo_vm01_intip"
}

variable "opdo_vm01_pubip" {
  default = "opdo_vm01_pubip"
}

variable "opdo_vm01_name" {
  default = "opdo-vm-01"
}