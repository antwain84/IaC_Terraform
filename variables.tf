variable "resource_group_location" {
    #default = "southCentralus"
    default = "East us 2"
    description = "location of the resource group"
}

variable "resource_group_name_prefix" {
    default = "soc" # was "rg"
    description = "prefix of the resource group"
}

variable "business_unit" {
    default = "soc"
}

variable "group_name"{
    default = ["group1", "group2", "group3"]
    type = list(string)
    description = "RG names"
}

variable "group_name_4each"{
    default = ["DEV", "UAT", "SIT"]
    type = set(string)
    description = "RG names"
}
