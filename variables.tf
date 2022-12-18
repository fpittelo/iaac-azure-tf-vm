variable "rg_name" {
  default = "iaac-azure-tf-vm"
}

variable "rg_location" {
  default = "Switzerland North"
}

variable "log_wks" {
  default = "vm-logs-wks"
}

variable "security_group" {
  default = "vm-sec-group"
}

variable "vm_vnet" {
  default = "vm-vnet"
}

variable "vm_subnet_int" {
  default = "vm-subnet-int"
}

variable "vm_subnet_pub" {
  default = "AzureFirewallSubnet"
}

variable "vm_01_ipcfg" {
  default = "vm-01-ipcfg"
}

variable "vm_01_nic" {
  default = "vm-01-nic"
}

variable "vm_01_intip" {
  default = "vm-01-intip"
}

variable "vm_01_pubip" {
  default = "vm-01-pubip"
}

variable "vm_01" {
  default = "vm-01"
}

variable "vm_count" {
  description = "Number of Virtual Machines"
  default     = 2
  type        = string
}

variable "vm_name_prefix" {
  description = "VM Names"
  default     = "vm"
  type        = string
}

variable "vm_fw" {
  description = "Vm Firewall"
  default     = "vm-fw"
  type        = string
}

variable "fw_pubip" {
  description = "Firewall Public IP"
  default     = "fw-pubip"
  type        = string
}

variable "fw_ipcfg" {
  description = "Firewall IP Config"
  default     = "fw-ipcfg"
  type        = string
}

variable "host_os" {
  description = "Select host os"
  type        = string
}