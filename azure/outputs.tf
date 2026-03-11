output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.main.name
}

output "vm_name" {
  description = "Name of the Virtual Machine (equivalent to AWS instance name tag)"
  value       = azurerm_linux_virtual_machine.web.name
}

output "vm_public_ip" {
  description = "Public IP address of the Virtual Machine (equivalent to AWS instance_public_ip)"
  value       = azurerm_public_ip.main.ip_address
}

output "vm_id" {
  description = "Resource ID of the Virtual Machine (equivalent to AWS instance ARN)"
  value       = azurerm_linux_virtual_machine.web.id
}

output "storage_account_name" {
  description = "Name of the Storage Account (equivalent to AWS s3_bucket_name)"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the Storage Account (equivalent to AWS S3 bucket URL)"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}
