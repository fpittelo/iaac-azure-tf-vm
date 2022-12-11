resource   "azurerm_resource_group"   "rg"   { 
  name   =   var.resource_group_name 
  location   =   var.resource_group_location 
}

resource "azurerm_log_analytics_workspace" "rg" {
  name                = var.azurerm_log_analytics_workspace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_network_security_group" "opdo" {
  name                = "opdo-sec-group"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name  
}

resource "azurerm_virtual_network" "opdo-net" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
  
  subnet {
    name           = "opdo-subnet-1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "opdo-subnet-2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.opdo.id
  }

  tags = {
    environment = "Production"
    owner       = "VPO-DSI-ISGOV-GE"
  }
}

