resource "azurerm_resource_group" "rg" {
  depends_on = [ random_string.random ]
  name = var.Resource_group_name
  location = var.Resource_group_Location
  tags = local.common_tages
  }