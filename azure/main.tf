provider "azurerm" {
    version = "~>2.0"
    features {}
}

provider "azurestack" {
  arm_endpoint    = "${var.arm_endpoint}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "automatechallenge" {
    name     = "myChallenge"
    location = "North Europe"

    tags = {
        environment = "Jenkins"
    }
}

resource "tls_private_key" "jenkins_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = tls_private_key.jenkins_ssh.private_key_pem }

resource "azurerm_network_security_group" "vmwebnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "North Europe"
    resource_group_name = azurerm_resource_group.automatechallenge.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Jenkins"
    }
}

resource "azurerm_linux_virtual_machine" "vmwebinst" {
    name                  = "myVM"
    location              = "North Europe"
    resource_group_name   = azurerm_resource_group.automatechallenge.name
    network_interface_ids = [azurerm_network_interface.vmwebint.id]
    size                  = "Standard_DS2_v3"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "20.04-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.jenkins_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Jenkins"
    }
}

resource "azurerm_public_ip" "vmwebpubip" {
    name                         = "myPublicIP"
    location                     = "North Europe"
    resource_group_name          = azurerm_resource_group.automatechallenge.name
    allocation_method            = "Static"

    tags = {
        environment = "Jenkins"
    }
}

resource "azurerm_network_interface" "vmwebint" {
    name                      = "myNIC"
    location                  = "North Europe"
    resource_group_name       = azurerm_resource_group.automatechallenge.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.vmwebsub.id
        private_ip_address_allocation = "Static"
        public_ip_address_id          = azurerm_public_ip.vmwebpubip.id
    }

    tags = {
        environment = "Jenkins"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.vmwebint.id
    network_security_group_id = azurerm_network_security_group.vmwebnsg.id
}