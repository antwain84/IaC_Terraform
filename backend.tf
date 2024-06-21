terraform {
  backend "azurerm" {
    resource_group_name  = "RESOURCE_GROUP"
    storage_account_name = "STORAGE_ACCT_NAME"
    container_name       = "CONTAINER_NAME"
    key                  = "terraform.tfstate"
  }
}