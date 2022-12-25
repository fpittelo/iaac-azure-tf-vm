
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location

  tags = {
    department        = var.vm_dpt_it
    environment       = var.vm_env_test
    owner             = var.vm_owner
  }

}

#resource "time_sleep" "wait_rg_creation" {
#  depends_on = [azurerm_resource_group.rg]
#  create_duration = "90s"
#}

resource "azurerm_log_analytics_workspace" "log_wks" {
  name                = var.log_wks
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on          = [azurerm_resource_group.rg]

  tags = {
    department        = var.vm_dpt_it
    environment       = var.vm_env_test
    owner             = var.vm_owner
  }

}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.vm_nsg
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

  tags = {
    department        = var.vm_dpt_it
    environment       = var.vm_env_test
    owner             = var.vm_owner
  }
}

resource "azurerm_virtual_network" "vm_net" {
  name                = var.vm_vnet
  address_space       = ["10.0.0.0/16"]
  location            = var.rg_location
  resource_group_name = var.rg_name
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
  depends_on          = [azurerm_resource_group.rg]

  tags = {
    department        = var.vm_dpt_it
    environment       = var.vm_env_test
    owner             = var.vm_owner
  }
}

resource "time_sleep" "wait_vnet_creation" {
  depends_on          = [azurerm_virtual_network.vm_net]
  create_duration     = "90s"
}

# Create subnet internal
resource "azurerm_subnet" "vm_subnet_int" {
  name                 = var.vm_subnet_int
  resource_group_name  = var.rg_name
  virtual_network_name = var.vm_vnet
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_resource_group.rg, azurerm_virtual_network.vm_net]
}

# Create subnet public
resource "azurerm_subnet" "vm_subnet_pub" {
  name                 = var.vm_subnet_pub
  resource_group_name  = var.rg_name
  virtual_network_name = var.vm_vnet
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_resource_group.rg, azurerm_virtual_network.vm_net]
}

# Create public IP
resource "azurerm_public_ip" "vm_pubip" {
  count                = var.vm_count
  name                 = "vm-pubip-${count.index}"
  location             = var.rg_location
  resource_group_name  = var.rg_name
  allocation_method    = "Dynamic"
  sku                  = "Basic"
  depends_on           = [azurerm_resource_group.rg]

  tags = {
    department         = var.vm_dpt_it
    environment        = var.vm_env_test
    owner              = var.vm_owner
  }
}

resource "azurerm_network_interface" "vm_nic" {
  count                = var.vm_count
# name                 = var.vm_name[count.index]
  name                 = "vm-nic-${count.index}"
  location             = var.rg_location
  resource_group_name  = var.rg_name
  depends_on           = [azurerm_resource_group.rg]

  ip_configuration {
    name                          = var.vm_01_ipcfg
    subnet_id                     = azurerm_subnet.vm_subnet_int.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm_pubip[count.index].id}"
  # public_ip_address_id          = element(azurerm_public_ip.vm_pubip.*.id, count.index)
  }

  tags = {
    department         = var.vm_dpt_it
    environment        = var.vm_env_test
    owner              = var.vm_owner
  }
}

#Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "vm-sec-assoc" {
  count = var.vm_count
  network_interface_id      = "${azurerm_network_interface.vm_nic[count.index].id}"
# network_interface_id      = element(azurerm_network_interface.vm_nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

resource "azurerm_linux_virtual_machine" "vm_linux" {
  count                           = var.vm_count
  name                            = "vm-${count.index}"
  resource_group_name             = var.rg_name
  location                        = var.rg_location
  size                            = "Standard_F2"
  admin_username                  = "adminfpi"
  admin_password                  = "L1nuxP0wer"
  disable_password_authentication = "false"
# network_interface_ids           = "${azurerm_network_interface.vm_nic[count.index].id}" 
  network_interface_ids           = [
    element(azurerm_network_interface.vm_nic.*.id, count.index)
 ,
  ]

  admin_ssh_key {
    username   = "adminfpi"
    public_key = file("~/.ssh/fredkey.pub")
  }

  custom_data = filebase64("customdata.tpl")

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "vm-disk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

# provisioner "local-exec" {
#   command = templatefile("${var.host_os}-ssh-script.tpl", {
#     hostname     = self.public_ip_address,
#     user         = "adminfpi"
#     identityfile = "~/.ssh/fredkey"
#   })
#   interpreter = ["Powershell", "-Command"]
# }

  tags = {
    department        = var.vm_dpt_it
    environment       = var.vm_env_test
    owner             = var.vm_owner
  }
}

resource "azurerm_virtual_machine_extension" "vm_extension" {
   count                      = var.vm_count
   name                       = var.vm_agent
   virtual_machine_id         = "${azurerm_linux_virtual_machine.vm_linux[count.index].id}"
#  virtual_machine_id         = element (azurerm_linux_virtual_machine.vm_linux.*.id, count.index)
   publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
   type                       = "MicrosoftMonitoringAgent"
   type_handler_version       = "1.0"
   auto_upgrade_minor_version = "true"
   depends_on                 = [azurerm_linux_virtual_machine.vm_linux]

    settings = <<SETTINGS
  {
     "workspaceId": "${azurerm_log_analytics_workspace.log_wks.workspace_id}"
  }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
  {
     "workspaceKey": "${azurerm_log_analytics_workspace.log_wks.primary_shared_key}"
  }
PROTECTED_SETTINGS
}

#data "azurerm_public_ip" "vm_01_pubipdata" {
#  name = azurerm_public_ip.vm_pubip.name
# resource_group_name = var.rg_name
#}

#output "vm_01_pubip" {
# value = "${azurerm_linux_virtual_machine.vm_linux.name}: ${data.azurerm_public_ip.vm_01_pubipdata.ip_address}"
#}