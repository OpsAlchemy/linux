data "azurerm_resource_group" "this" {
  name = "infraera-example-demo"
}

data "azurerm_virtual_network" "this" {
  name                = "example-network"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "workloads" {
  name                 = "internal"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_resource_group.this.name
}
