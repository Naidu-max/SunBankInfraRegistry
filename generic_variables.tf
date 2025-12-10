variable "Bussiness_Division" {
    description = "This variable for bussiness division like hr,sap,retail"
  type = string
}
variable "Environment" {
    description = "This variable for which environment like test,staging,prod"
    type = string
  
}
variable "Resource_group_name" {
    type=string  
}
variable "Resource_group_Location" {
    type = string
  
}