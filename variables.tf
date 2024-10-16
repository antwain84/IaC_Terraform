variable "resource_group_location" {
    default = "WEST US"
    description = "location of the resource group"
}

variable "resource_group_name_prefix" {
    default = "A84" # was "rg"
    description = "prefix of the resource group"

}

variable "business_unit" {
    default = "A84"
}

variable "allowed_ips" {
    type    = list(string)
    default = [
            "123.123.123.1/16",
            "192.159.16.1/16"
    ]
}

