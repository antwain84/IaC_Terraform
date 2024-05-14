variable "resource_group_location" {
    default = "southCentralus"
    description = "location of the resource group"
}

variable "resource_group_name_prefix" {
    default = "soc" # was "rg"
    description = "prefix of the resource group"

}

variable "business_unit" {
    default = "soc"
}