variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vm_size" {
  description = "Size of the Azure Virtual Machine (equivalent to AWS instance_type)"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "adminuser"
}

variable "admin_ssh_public_key_path" {
  description = "Path to the SSH public key file for VM authentication"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account (must be globally unique, 3-24 lowercase alphanumeric chars)"
  type        = string
  default     = "mylearningterraformsa"
}
