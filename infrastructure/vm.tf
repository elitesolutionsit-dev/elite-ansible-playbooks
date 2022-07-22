resource "azurerm_resource_group" "elite_general_resources" {
  name     = local.elite_general_resources
  location = var.location
}

resource "azurerm_network_interface" "labnic" {
  name                = join("-", [local.server, "lab", "nic"])
  location            = local.buildregion
  resource_group_name = azurerm_resource_group.elite_general_resources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.application_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.labpip.id
  }
}

resource "azurerm_public_ip" "labpip" {
  name                = join("-", [local.server, "lab", "pip"])
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  location            = local.buildregion
  allocation_method   = "Static"

  tags = local.common_tags
}


resource "azurerm_linux_virtual_machine" "Linuxvm" {
  name                = join("-", [local.server, "linux", "vm"])
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  location            = local.buildregion
  size                = "Standard_DS1"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.labnic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGNReN8qtWGfBL96RbTip2cz/2p1D8CtZIH3uzZj0Ikd9Qc70Hh/3qfDXkP+d1KH+wFfcr0C1gpgBaf0qZRJZsup183lmxSUjtv/6kChNXWMcxo7GavOQmTXRIsX4DOUEt7+N1wWCEKB28rrVBqJzBYh3h0Ll1WyHK16QDunul8Dz360ENZ2r8CFtRODPMSi8OcEP+cSvJV+wXC/7LqCNOxjApE9WFdLiTjXItyfWghNqdtXeWj4vEM3sPqM9rB92zH/MtFSCnsC2qxg18TfY8sWWh/KJiBrBa/wVu/GGJ5TNOlo8C9RuLEBieUUy4l58JtSfre+7maqEFjS6JwsI11oW8/PfroYz2wGYqNr8WSBBaOR2r6dDgktucmsoHcN1CzPaPLDlGt/LWrJh/Sl0y7cFpyBP2OeZKKUcfhgFNaA+KT+N6EnzXFa2+bIb9t+at5FaErMZG0ITyStBaPvmRNiTjTJ1lQYlw9RchlV7Syx6PXOpVQ2yWZEgrWojkT7E= lbena@LAPTOP-QB0DU4OG"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}