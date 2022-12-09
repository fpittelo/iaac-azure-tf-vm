provider   "azurerm"   { 
   version   =   "= 3.0.0" 
   features   {} 
 }
 resource   "azurerm_resource_group"   "rg"   { 
   name   =   "iaac-opdo" 
   location   =   "Switzerland North" 
 }

