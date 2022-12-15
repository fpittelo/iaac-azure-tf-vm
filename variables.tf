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

variable "opdo_vnet" {
  default = "opdo-vnet"
}

variable "opdo_subnet_int" {
  default = "opdo-subnet-int"
}

variable "opdo_subnet_pub" {
  default = "opdo-subnet-pub"
}

variable "opdo_vm_ipcfg" {
    default = "opdo-vm-ipcfg"
}

variable "opdo_vm_nic" {
    default = "opdo-vm-nic"
}

variable "opdo_vm_intip" {
  default = "opdo-vm-intip"
}

variable "opdo_vm_pubip" {
  default = "opdo-vm-pubip"
}

variable "opdo_vm_name" {
  default = "opdo-vm-01"
}

variable "vm_count" {
  description = "Number of Virtual Machines"
  default     = 2
  type        = string
}

variable "vm_name_prefix" {
  description = "VM Names"
  default     = "opdo-vm"
  type        = string
}