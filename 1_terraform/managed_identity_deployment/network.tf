## network
# vnet
resource "azurerm_virtual_network" "deployemnt_vnet" {
  name                = "${azurerm_resource_group.deployment.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location_short
  resource_group_name = azurerm_resource_group.deployment.name
}
# subnet
resource "azurerm_subnet" "deployment_subnet" {
  name                 = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-subnet"
  resource_group_name  = azurerm_resource_group.deployment.name
  virtual_network_name = azurerm_virtual_network.deployemnt_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# public IPs
resource "azurerm_public_ip" "deployment_pip" {
  name                = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-pip"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.deployment.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.domain_name_label
}
# Network Security Group and rule
resource "azurerm_network_security_group" "deployment-nsg" {
  name                = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-deployment-nsg"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.deployment.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "217.168.43.146"
    destination_address_prefix = "*"
  }
}
# network interface
resource "azurerm_network_interface" "deployemnt_nic" {
  name                = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-deployment-nic"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.deployment.name

  ip_configuration {
    name                          = "deployment_ip_config"
    subnet_id                     = azurerm_subnet.deployment_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.deployment_pip.id
  }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.deployemnt_nic.id
  network_security_group_id = azurerm_network_security_group.deployment-nsg.id
}
