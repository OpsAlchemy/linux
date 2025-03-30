











resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "random_integer" "zone_index" {
  max = 3
  min = 1
}




module "linuxvm" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.18.1"


  admin_username                     = "azureuser"
  encryption_at_host_enabled         = false
  generate_admin_password_or_ssh_key = false

  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_size            = var.sku_size
  zone                = random_integer.zone_index.result

  admin_ssh_keys = [
    {
      public_key = tls_private_key.this.public_key_openssh
      username   = "azureuser"
    }
  ]
 
  managed_identities = var.managed_identities

  network_interfaces = var.network_interfaces

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    
  }


  source_image_reference = var.source_image_reference
  enable_telemetry       = false
  tags                   = var.tags
}
