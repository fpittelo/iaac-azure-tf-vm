
resource   "azurerm_resource_group"   "rg"   { 
  name                =   var.rg_name 
  location            =   var.rg_location 
}

resource "time_sleep" "wait_rg_creation" {
  depends_on = [azurerm_resource_group.rg]
  create_duration = "90s"
}

resource "azurerm_log_analytics_workspace" "opdo_log_wks" {
  name                = var.opdo_log_wks
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_network_security_group" "opdo" {
  name                = var.security_group
  location            = var.rg_location
  resource_group_name = var.rg_name
  depends_on          = [azurerm_resource_group.rg]
  
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "opdo_vnet" {
  name                = var.opdo_vnet
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
  virtual_network_name = var.opdo_vnet
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.opdo_vnet]
}

# Create subnet public
resource "azurerm_subnet" "opdo_subnet_pub" {
  name                 = var.opdo_subnet_pub
  resource_group_name  = var.rg_name
  virtual_network_name = var.opdo_vnet
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.opdo_vnet]
}

# Create private IP
resource "azurerm_public_ip" "opdo_vm_01_intip" {
  name                = var.opdo_vm_01_intip
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
  depends_on          = [azurerm_resource_group.rg]
}

# Create public IP
resource "azurerm_public_ip" "opdo_vm_01_pubip" {
  name                = var.opdo_vm_01_pubip
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_network_interface" "opdo_vm_01_nic" {
  name                = var.opdo_vm_01_nic
  location            = var.rg_location
  resource_group_name = var.rg_name
  depends_on          = [azurerm_resource_group.rg]

  ip_configuration {
    name                          = var.opdo_vm_01_ipcfg
    subnet_id                     = azurerm_subnet.opdo_subnet_int.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.opdo_vm_01_pubip.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "opdo-sec-assoc" {
  network_interface_id      = azurerm_network_interface.opdo_vm_01_nic.id
  network_security_group_id = azurerm_network_security_group.opdo.id
}

resource "azurerm_linux_virtual_machine" "opdo-vm-01" {
  name                  = var.opdo_vm_01_name
  resource_group_name   = var.rg_name
  location              = var.rg_location
  size                  = "Standard_F2"
  admin_username        = "adminfpi"
  admin_password        = "L1nuxP0wer"
  disable_password_authentication = "false"
  network_interface_ids = [azurerm_network_interface.opdo_vm_01_nic.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = var.opdo_vm_01_name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    environment = "production"
    owner       = "VPO-DSI-ISGOV-GOV"
  }
}