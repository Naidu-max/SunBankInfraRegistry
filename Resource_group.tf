resource "azurerm_resource_group" "rg" {
  depends_on = [ random_string.random ]
  name = "${local.resource_pefiex}-${var.Resource_group_name}"
  location = var.Resource_group_Location
  tags = local.common_tages
  }