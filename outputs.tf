#output "resource_group_name" {
# value = azurerm_resource_group.rg.name
#}

#output "vm_pubip_list" {
# value = azurerm_linux_virtual_machine.vm_pubip.*.name
#}

#output "vm_pubip_list_id" {
#   value = azurerm_linux_virtual_machine.List.name
#}

#output "tls_private_key" {
# value     = tls_private_key.example_ssh.private_key_pem
# sensitive = true
#}