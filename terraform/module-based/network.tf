# Create Network
module "network" {
  source              = "Azure/network/azurerm"
  version             = "3.2.1"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = var.vnet_name
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names        = ["windows", "linux"]
  tags                = var.global_settings.tags
  depends_on          = [azurerm_resource_group.rg]
}
# Create NSG

module "network-security-group" {
  source                = "Azure/network-security-group/azurerm"
  version               = "3.4.1"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location_short # Optional; if not provided, will use Resource Group location
  security_group_name   = var.nsg_name
  source_address_prefix = ["*"]

  custom_rules = [
    {
      name                   = "rdp_access"
      priority               = 500
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp" #case sensitive
      source_port_range      = "*"
      destination_port_range = "3389"
      source_address_prefix  = "185.40.216.73"
      description            = "rdp-in-win"
    },
    {
      name                   = "ssh_access"
      priority               = 501
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp" #case sensitive
      source_port_range      = "*"
      destination_port_range = "21"
      source_address_prefix  = "185.40.216.73"
      description            = "ssh-in-linux"
    }
  ]
  tags       = var.global_settings.tags
  depends_on = [azurerm_resource_group.rg]
}
# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association0" {
  subnet_id                 = module.network.vnet_subnets[0]
  network_security_group_id = module.network-security-group.network_security_group_id
}
# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association1" {
  subnet_id                 = module.network.vnet_subnets[1]
  network_security_group_id = module.network-security-group.network_security_group_id
}
