locals {
  vm_names = ["hydrogen", "helium", "lithium"]
}

resource "azurerm_user_assigned_identity" "swarm" {
  name                = "swarm-identity"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
}
resource "azurerm_network_security_group" "swarm_node_nsg" {
  name                = "nsg-combined"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-visualizer"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-postgres"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-elastic-search"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-result-app"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-portainer"
    priority                   = 1007
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
    project     = "jin40"
  }
}



module "swarm-cluster" {
  for_each = toset(local.vm_names)

  source = "../modules/vm"

  location            = data.azurerm_resource_group.this.location
  name                = each.key
  resource_group_name = data.azurerm_resource_group.this.name
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  managed_identities = {
    user_assigned_resource_ids = [azurerm_user_assigned_identity.swarm.id]
  }

  network_interfaces = {
    network_interface = {
      name = "nic-${each.key}"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig-${each.key}"
          private_ip_subnet_resource_id = data.azurerm_subnet.this.id
          create_public_ip_address      = true
          public_ip_address_name        = "pip-${each.key}"
        }
      }
      network_security_groups = {
        swarm_node_nsg = {
          network_security_group_resource_id = azurerm_network_security_group.swarm_node_nsg.id
        }
      }
    }
  }

  tags = {
    environment = "dev"
    project     = "jin40"
    node        = "${each.key}"
  }
}


resource "local_file" "private_keys" {
  for_each = toset(local.vm_names)

  content         = module.swarm-cluster[each.key].private_key_pem
  filename        = "${path.module}/swarm/keys/${each.key}.pem"
  file_permission = "0600"
}

resource "local_file" "public_ip_json" {
  content  = jsonencode({ for vm in local.vm_names : vm => module.swarm-cluster[vm].vm_public_ips })
  filename = "${path.module}/swarm/public-ip.json"
}
