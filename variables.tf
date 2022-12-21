variable "rg_name" {
  default = "iaac-azure-tf-vm"
}

variable "rg_location" {
  default = "Switzerland North"
}

variable "log_wks" {
  default = "vm-logs-wks"
}

variable "vm_nsg_01" {
  default = "vm_nsg_01"
  description = "Network Security Group"
  type = string
}

variable "vm_vnet" {
  default = "vm-vnet"
}

variable "vm_subnet_int" {
  description  = "Vm internal subnet"
  default      = "vm-subnet-int"
  type         = string
}

variable "vm_subnet_pub" {
  description  = "Vm public subnet"
  default      = "vm-subnet-pub"
  type         = string
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
  type        = number
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

variable vm_intip_list {
    type = list(string)
    description = "List of all private IP's"
}

variable vm_pubip_list {
    type = list(string)
    description = "List of all public IP's"
}

variable "vm_name_prefix" {
  description = "VM Names"
  default     = "vm"
  type        = string
}

variable "vm_ip_space" {
  default = ["10.0.0.0/16"]
}

variable "vm_ip_prefix" {
  description = "IP Subnet"
  default     = "1.0.1.0/24"
  type        = string
}

#variable for department
variable "department" {
type = string
default = "IT"
}

#variable for test environment
variable "vm_test_env" {
type = string
}

#variable for owner
variable "vm_owner" {
type = string
default = "Fred"
}