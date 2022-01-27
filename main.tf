resource "azurerm_resource_group" "resource_gp" {
  name     = "x2pr_demo"
  location = "Southeast Asia"

  tags {
    Owner = "John Christopher"
  }
}

variable "prefix" {
  default = "sl"
}


resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.resource_gp.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name = "${azurerm_resource_group.resource_gp.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.resource_gp.location}"
  resource_group_name   = "${azurerm_resource_group.resource_gp.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"
 
  tags {
    Owner = "John Christopher"
  }
}