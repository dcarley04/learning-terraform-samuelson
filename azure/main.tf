# ---------------------------------------------------------------------------
# Resource Group — container for all Azure resources
# (no direct AWS equivalent; AWS uses regions/accounts directly)
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = "rg-learning-terraform-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "learning-terraform"
  }
}

# ---------------------------------------------------------------------------
# Networking — VNet, Subnet, Public IP, NIC
# Equivalent AWS resources: VPC, Subnet, Elastic IP, ENI
# ---------------------------------------------------------------------------
resource "azurerm_virtual_network" "main" {
  name                = "vnet-learning-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-main"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "pip-learning-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_network_interface" "main" {
  name                = "nic-learning-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    Environment = var.environment
  }
}

# ---------------------------------------------------------------------------
# Linux Virtual Machine — Ubuntu 22.04 LTS with Tomcat installed via cloud-init
# Equivalent AWS resource: aws_instance (Bitnami Tomcat AMI)
# ---------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "web" {
  name                = "vm-web-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.admin_ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Ubuntu 22.04 LTS — standard image, no marketplace plan required
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Cloud-init: install and start Apache Tomcat (equivalent to Bitnami Tomcat AMI)
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y tomcat10
    systemctl enable tomcat10
    systemctl start tomcat10
  EOF
  )

  tags = {
    Name        = "HelloWorld"
    Environment = var.environment
  }
}

# ---------------------------------------------------------------------------
# Storage Account + Container
# Equivalent AWS resource: aws_s3_bucket
# ---------------------------------------------------------------------------
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Versioning on blob level (equivalent to aws_s3_bucket_versioning)
  blob_properties {
    versioning_enabled = true
  }

  # Block all public access (equivalent to aws_s3_bucket_public_access_block)
  public_network_access_enabled = false

  tags = {
    Name        = "App Storage"
    Environment = var.environment
  }
}

resource "azurerm_storage_container" "app" {
  name                  = "app-container"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}
