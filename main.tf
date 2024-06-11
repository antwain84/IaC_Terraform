########################################################
#
# creates Windows vm using the variables.tf and provider.tf
#
########################################################

resource "random_string" "sub_name" {
    length = 4
    min_lower = 2
    min_numeric = 2
}

resource "random_string" "sub_name2" {
    length = 4
    min_lower = 2
    min_numeric = 2
}

resource "azurerm_resource_group" "DevSecOps" {
    name = "${var.business_unit}-DevSecOps-${random_string.sub_name2.id}"
    location = var.resource_group_location
}

resource "azurerm_resource_group" "test2" {
    for_each = var.group_name_4each
    name = "${var.business_unit}-${each.value}"
    #name = "${var.business_unit}-${each.value}-${random_string.sub_name2.id}"  #WORKS: random_string.sub_name2.id creates only 1 unique ID and it's used on all RGs created
    location = var.resource_group_location
}


resource "azurerm_windows_virtual_machine" "win-test-02" {
  name                = "${var.business_unit}-${random_string.sub_name.id}-${random_string.sub_name2.id}"
  resource_group_name = azurerm_resource_group.DevSecOps.name
  location            = var.resource_group_location
  size                = "Standard_D1_v2" #D2lds_v5
  admin_username      = "admin"
  admin_password      = "MyAdmin@15"
  network_interface_ids = [
    azurerm_network_interface.win-test-01480_z2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "win-test-01480_z2" {
  name                = "win-test-01480_z2"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.DevSecOps.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network" "win-test-0145AS84-vnet" {
  name                = "win-test-0145AS84-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.DevSecOps.name
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.DevSecOps.name
  virtual_network_name = azurerm_virtual_network.win-test-0145AS84-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}
