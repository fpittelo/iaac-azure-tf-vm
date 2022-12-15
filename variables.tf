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
  default = "AzureFirewallSubnet"
}

variable "opdo_vm_ipcfg" {
    default = "opdo-vm-ipcfg"
}

variable "opdo_vm_nic" {
    default = "opdo-vm-nic"
}

variable "opdo_vm_01_intip" {
  default = "opdo-vm-01-intip"
}

variable "opdo_vm_01_pubip" {
  default = "opdo-vm-01-pubip"
}

variable "opdo_vm_01" {
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

variable "opdo_fw" {
  description = "OPDO Firewall"
  default     = "opdo-fw"
  type        = string
}

variable "opdo_fw_pubip" {
  description = "OPDO Firewall Public IP"
  default     = "opdo-fw-pubip"
  type        = string
}

variable "opdo_fw_ipcfg" {
  description = "OPDO Firewall IP Config"
  default     = "opdo-fw-ipcfg"
  type        = string
}