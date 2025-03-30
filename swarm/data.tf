data "azurerm_resource_group" "this" {
  name = "rg-jin40-dev-uksouth-01"
}

data "azurerm_virtual_network" "this" {
  name = "vnet-jin40-dev-uksouth-01"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  name = "workloads"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name = data.azurerm_resource_group.this.name
}