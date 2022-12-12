
resource   "azurerm_resource_group"   "rg"   { 
  name                =   var.rg_name 
  location            =   var.rg_location 
}

resource "time_sleep" "wait_rg_creation" {
  depends_on = [azurerm_resource_group.rg]
  create_duration = "90s"
}

resource "azurerm_log_analytics_workspace" "logwks" {
  name                = var.log_analytics_wks
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_network_security_group" "opdo" {
  name                = var.log_analytics_wks
  location            = var.rg_location
  resource_group_name = var.rg_name
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_virtual_network" "opdo_vnet" {
  name                = var.opdo_virtual_net
  address_space       = ["10.0.0.0/16"]
  location            = var.rg_location
  resource_group_name = var.rg_name
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "time_sleep" "wait_vnet_creation" {
  depends_on = [azurerm_virtual_network.opdo_vnet]
  create_duration = "90s"
}

# Create subnet internal
resource "azurerm_subnet" "opdo_subnet_int" {
  name                 = var.opdo_subnet_int
  resource_group_name  = var.rg_name
  virtual_network_name = var.opdo_virtual_net
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.opdo_vnet]
}

# Create subnet public
resource "azurerm_subnet" "opdo_subnet_pub" {
  name                 = var.opdo_subnet_pub
  resource_group_name  = var.rg_name
  virtual_network_name = var.opdo_virtual_net
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.opdo_vnet]
}

# Create private IP
resource "azurerm_public_ip" "opdo_vm01_intip" {
  name                = var.opdo_vm01_intip
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

# Create public IP
resource "azurerm_public_ip" "opdo_vm01_pubip" {
  name                = var.opdo_vm01_pubip
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "opdo_vm01_nic" {
  name                = var.opdo_vm01_nic
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.opdo_vm01_ipcfg
    subnet_id                     = azurerm_subnet.opdo_subnet_int.id
    private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "opdo-vm-01" {
  name                = var.opdo_vm01_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.opdo_vm01_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}