resource   "azurerm_resource_group"   "rg"   { 
  name   =   "IAAC-AZURE-OPDO" 
  location   =   "Switzerland North" 
}

resource "azurerm_log_analytics_workspace" "rg" {
  name                = "iaac-azure-opdo-logs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}