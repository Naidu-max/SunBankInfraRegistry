variable "Vnet_name" {
    type = string
  
}
variable "Vnet_address_prefix" {
  type = list(string)
}

variable "web_Tier_subnet" {
    type = string
  
}

variable "app_Tier_subnet" {
    type = string
  
}
variable "DB_Tier_subnet" {
    type = string
  
}
variable "Bastion_Tier_subnet" {
    type = string
  
}

variable "web_Tier_subnet_address_prefix" {
    type = list(string)
  
}
variable "app_Tier_subnet_address_prefix" {
    type = list(string)
  
}
variable "DB_Tier_subnet_address_prefix" {
    type = list(string)
  
}
variable "Bastion_app_Tier_subnet_address_prefix" {
    type = list(string)
  
}

