resource "azurerm_virtual_network" "Vnet" {
    
    name="${local.resource_pefiex}-${var.Vnet_name}"
  resource_group_name = var.Resource_group_name
  location = var.Resource_group_Location
  address_space = var.Vnet_address_prefix
  }

  resource "azurerm_subnet" "web_Tier_subnet" {
  name = "${azurerm_virtual_network.Vnet.name}-${var.web_Tier_subnet}"
  address_prefixes =var.web_Tier_subnet_address_prefix
  virtual_network_name = azurerm_virtual_network.Vnet.name
  resource_group_name = var.Resource_group_name
    
  }

  resource "azurerm_subnet" "app_Tier_subnet" {
  name = "${azurerm_virtual_network.Vnet.name}-${var.app_Tier_subnet}"
  address_prefixes =var.app_Tier_subnet_address_prefix
  virtual_network_name = azurerm_virtual_network.Vnet.name
  resource_group_name = var.Resource_group_name
    
  }


  resource "azurerm_subnet" "DB_Tier_subnet" {
  name = "${azurerm_virtual_network.Vnet.name}-${var.DB_Tier_subnet}"
  address_prefixes =var.DB_Tier_subnet_address_prefix
  virtual_network_name = azurerm_virtual_network.Vnet.name
  resource_group_name = var.Resource_group_name
    
  }

  resource "azurerm_subnet" "Bastion_Tier_subnet" {
  name = "${azurerm_virtual_network.Vnet.name}-${var.Bastion_Tier_subnet}"
  address_prefixes =var.Bastion_app_Tier_subnet_address_prefix
  virtual_network_name = azurerm_virtual_network.Vnet.name
  resource_group_name = var.Resource_group_name
    
  }

resource "azurerm_network_security_group" "Web_nsg" {
    depends_on = [ azurerm_resource_group.rg ]
  name = "${var.web_Tier_subnet}-nsg"
  location = var.Resource_group_Location
  resource_group_name = var.Resource_group_name
  
}

resource "azurerm_network_security_group" "app_nsg" {
    depends_on = [ azurerm_resource_group.rg ]
  name = "${var.app_Tier_subnet}-nsg"
  location = var.Resource_group_Location
  resource_group_name = var.Resource_group_name
  
}

resource "azurerm_network_security_group" "DB_nsg" {
    depends_on = [ azurerm_resource_group.rg ]
  name = "${var.DB_Tier_subnet}-nsg"
  location = var.Resource_group_Location
  resource_group_name = var.Resource_group_name
  
}
resource "azurerm_network_security_group" "Bastion_nsg" {
    depends_on = [ azurerm_resource_group.rg ]
  name = "${var.Bastion_Tier_subnet}-nsg"
  location = var.Resource_group_Location
  resource_group_name = var.Resource_group_name
  
}


locals {
  web_Nsg_ports={
"110":"80"
"120":"443"
"130":"8080"
"140":"22"

  }
db_inbound_ports_map = {
    "100" : "3306", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "1433",
    "120" : "5432"
  } 

bastion_inbound_ports_map = {
    "100" : "22", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "3389"
  } 


}






resource "azurerm_network_security_rule" "Inbound_rules_web_tier" {
for_each = local.web_Nsg_ports
  name                        = "port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = each.value
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.Resource_group_name
  network_security_group_name = azurerm_network_security_group.Web_nsg.name

  depends_on = [ azurerm_network_security_group.Web_nsg ]
}

resource "azurerm_network_security_rule" "Inbound_rules_app_tier" {
for_each = local.web_Nsg_ports
  name                        = "port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = each.value
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.Resource_group_name
  network_security_group_name = azurerm_network_security_group.app_nsg.name

}

resource "azurerm_network_security_rule" "Inbound_rules_DB_tier" {
for_each = local.db_inbound_ports_map
  name                        = "port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = each.value
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.Resource_group_name
  network_security_group_name = azurerm_network_security_group.DB_nsg.name

}

resource "azurerm_network_security_rule" "Inbound_rules_Bastion_tier" {
for_each = local.bastion_inbound_ports_map
  name                        = "port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = each.value
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.Resource_group_name
  network_security_group_name = azurerm_network_security_group.Bastion_nsg.name

}


resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
  depends_on = [azurerm_network_security_rule.Inbound_rules_web_tier]    
  subnet_id                 = azurerm_subnet.web_Tier_subnet.id
  network_security_group_id = azurerm_network_security_group.Web_nsg.id
}


resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg_associate" {
  depends_on = [azurerm_network_security_rule.Inbound_rules_app_tier]    
  subnet_id                 = azurerm_subnet.app_Tier_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "DB_subnet_nsg_associate" {
  depends_on = [azurerm_network_security_rule.Inbound_rules_DB_tier]    
  subnet_id                 = azurerm_subnet.DB_Tier_subnet.id
  network_security_group_id = azurerm_network_security_group.DB_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "Bastion_subnet_nsg_associate" {
  depends_on = [azurerm_network_security_rule.Inbound_rules_Bastion_tier]    
  subnet_id                 = azurerm_subnet.Bastion_Tier_subnet.id
  network_security_group_id = azurerm_network_security_group.Bastion_nsg.id
}


