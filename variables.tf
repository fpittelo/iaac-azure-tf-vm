variable "rg_name" {
  default = "iaac-azure-opdo"
}

variable "rg_location" {
  default = "Switzerland North"
}

variable "opdo_log_wks" {
  default = "opdo-logs-wks"
}

variable "security_group" {
  default = "opdo-sec-group"
}

variable "prefix" {
  default = "opdo"
}

variable "opdo_vnet" {
  default = "opdo-vnet"
}

variable "opdo_subnet_int" {
  default = "opdo-subnet-int"
}

variable "opdo_subnet_pub" {
  default = "opdo-subnet-pub"
}

variable "opdo_vm_01_ipcfg" {
    default = "opdo-vm-01-ipcfg"
}

variable "opdo_vm_01_nic" {
    default = "opdo-vm-01-nic"
}

variable "opdo_vm_01_intip" {
  default = "opdo-vm-01-intip"
}

variable "opdo_vm_01_pubip" {
  default = "opdo-vm-01-pubip"
}

variable "opdo_vm_01_name" {
  default = "opdo-vm-01"
}