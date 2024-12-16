########################################################
# creates the following resources in Azure
# DevSecOps resource group
# storage account
# blob account with index.html file for static website
# 3 resource groups using for_each
# Windows server VM
# network interface
# virtual network
# subnet
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

resource "azurerm_storage_account" "my_storage" {
    name                        = "${var.business_unit}storage${random_string.sub_name2.id}"
    resource_group_name         = azurerm_resource_group.DevSecOps.name
    location                    = var.resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    account_kind                = "StorageV2"  #STATIC WEBSITE PROPERTY 

    static_website{
        index_document = "index.html"
    }
}

#STORAGE BLOB WITHIN STROAGE ACCOUNT
resource "azurerm_storage_blob" "blob" {
    name                    = "index.html"
    storage_account_name    = azurerm_storage_account.my_storage.name  #reference jthe storage account previously created
    storage_container_name  = "$web"
    type                    = "Block"
    content_type            = "text/html"
    #source_content         = "<h1> Hello, Mr. Salisbury </h1>"
    source                  = "index.html"
  
}


resource "azurerm_resource_group" "test2" {     # test2 is the reference name in the terraform file
    for_each = var.group_name_4each
    name = "${var.business_unit}-${each.value}"
    location = var.resource_group_location
}



resource "azurerm_windows_virtual_machine" "win-test-02" {
  name                = "${var.business_unit}-${random_string.sub_name.id}-${random_string.sub_name2.id}"
  resource_group_name = azurerm_resource_group.DevSecOps.name
  location            = var.resource_group_location
  size                = "Standard_D1_v2" #D2lds_v5
  admin_username      = "admineight4"
  admin_password      = "MyAdM345@12"
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

resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.DevSecOps.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "allow-rdp"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.DevSecOps.name
  allocation_method   = "Dynamic"
}
