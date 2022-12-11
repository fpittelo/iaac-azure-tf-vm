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

resource "azurerm_virtual_network" "opdo-net" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}